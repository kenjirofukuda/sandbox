#include <Application.h>
#include <Window.h>

int
main (int argc, char **argv)
{
	BApplication app("application/x-vnd.me-TestApp");
	BWindow *win = new BWindow(BRect (0, 0, 640, 480),
							   "TestApp",
							   B_TITLED_WINDOW,
							   B_QUIT_ON_WINDOW_CLOSE);
	win->CenterOnScreen();
	win->Show();
	app.Run();
	return 0;
}
