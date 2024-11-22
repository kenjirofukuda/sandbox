// @see https://ethanc8.github.io/NewDocumentation-Tutorials/AppsWithCodeOnly/GettingStarted/5_Windows.html

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

@interface MyDelegate : NSObject
{
  NSWindow *myWindow;
}
- (void) createMenu;
- (void) createWindow;
- (void) applicationWillFinishLaunching: (NSNotification *)not;
- (void) applicationDidFinishLaunching: (NSNotification *)not;
@end

@implementation MyDelegate : NSObject
- (void) dealloc
{
  RELEASE(myWindow);
  DEALLOC;
}

- (void) createMenu
{
  NSMenu *menu;

  menu = AUTORELEASE([NSMenu new]);

  [menu addItemWithTitle: @"Quit"
                  action: @selector(terminate:)
           keyEquivalent: @"q"];

  [NSApp setMainMenu: menu];
}

- (void) createWindow
{
  NSRect rect = NSMakeRect(100, 100, 800, 600);
  unsigned int styleMask = NSWindowStyleMaskBorderless
                           | NSWindowStyleMaskTitled
                           | NSWindowStyleMaskClosable
                           | NSWindowStyleMaskMiniaturizable
                           | NSWindowStyleMaskResizable;

  myWindow = [[NSWindow alloc] initWithContentRect: rect
                                         styleMask: styleMask
                                           backing: NSBackingStoreBuffered
                                             defer: NO];
  [myWindow setTitle: @"This is a test window"];
  [myWindow center];
}

- (void) applicationWillFinishLaunching: (NSNotification *)not
{
  [self createMenu];
  [self createWindow];
}

- (void) applicationDidFinishLaunching: (NSNotification *)not;
{
  [myWindow makeKeyAndOrderFront: nil];
}

- (void) someMethod
{

}
@end

int main(int argc, const char **argv)
{
  [NSApplication sharedApplication];
  [NSApp setDelegate: [MyDelegate new]];
  return NSApplicationMain(argc, argv);
}
