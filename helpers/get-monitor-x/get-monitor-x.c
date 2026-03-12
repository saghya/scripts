#include <stdio.h>
#include <stdlib.h>
#include <X11/Xlib.h>
#include <X11/extensions/Xinerama.h>

static void die(const char *msg)
{
    fprintf(stderr, "%s\n", msg);
    exit(1);
}

int main()
{
    Display *dpy = XOpenDisplay(NULL);
    if (!dpy)
        die("cannot open display");

    Window       root = DefaultRootWindow(dpy);
    Window       dummy_win;
    int          dummy_int;
    unsigned int dummy_uint;
    int          root_x = 0;
    int          root_y = 0;

    if (!XQueryPointer(dpy, root, &dummy_win, &dummy_win, &root_x, &root_y,
                       &dummy_int, &dummy_int, &dummy_uint)) {
        XCloseDisplay(dpy);
        die("cannot query pointer");
    }

    int mon  = 0;
    int xoff = 0;

    if (XineramaIsActive(dpy)) {
        int                 screens = 0;
        XineramaScreenInfo *info    = XineramaQueryScreens(dpy, &screens);

        if (info) {
            for (int i = 0; i < screens; ++i) {
                if (root_x >= info[i].x_org &&
                    root_x < info[i].x_org + info[i].width &&
                    root_y >= info[i].y_org &&
                    root_y < info[i].y_org + info[i].height) {
                    mon  = i;
                    xoff = info[i].x_org;
                    break;
                }
            }
            XFree(info);
        }
    }

    XCloseDisplay(dpy);

    int x = root_x - xoff;
    if (x < 0)
        x = 0;

    printf("%d %d\n", mon, x);
    return 0;
}

