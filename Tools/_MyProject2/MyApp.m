// @see https://ethanc8.github.io/NewDocumentation-Tutorials/AppsWithCodeOnly/GettingStarted/6_Buttons.html

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface MyDelegate : NSObject
{
  NSWindow *myWindow;
}
- (void) printHello: (id)sender;
- (void) createMenu;
- (void) createWindow;
- (void) applicationWillFinishLaunching: (NSNotification *)not;
- (void) applicationDidFinishLaunching: (NSNotification *)not;
@end

@implementation MyDelegate : NSObject
- (void) dealloc
{
  RELEASE (myWindow);
  [super dealloc];
}

- (void) printHello: (id)sender
{
  printf ("Hello!\n");
}

- (void) createMenu
{
  NSMenu *menu;

  menu = AUTORELEASE ([NSMenu new]);

  [menu addItemWithTitle: @"Quit"
                  action: @selector (terminate:)

           keyEquivalent: @"q"];

  [NSApp setMainMenu: menu];
}

- (void) createWindow
{
  NSRect rect;
  unsigned int styleMask = NSTitledWindowMask
                         | NSMiniaturizableWindowMask;
  NSButton *myButton;
  NSSize buttonSize;

  myButton = AUTORELEASE ([NSButton new]);
  [myButton setTitle: @"Print Hello!"];
  [myButton sizeToFit];
  [myButton setTarget: self];
  [myButton setAction: @selector (printHello:)];

  buttonSize = [myButton frame].size;
  rect = NSMakeRect (100, 100,
                     buttonSize.width,
                     buttonSize.height);

  myWindow = [NSWindow alloc];
  myWindow = [myWindow initWithContentRect: rect
                                 styleMask: styleMask
                                   backing: NSBackingStoreBuffered
                                     defer: NO];
  [myWindow setTitle: @"This is a test window"];
  [myWindow setContentView: myButton];
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
@end

int main (int argc, const char **argv)
{
  [NSApplication sharedApplication];
  [NSApp setDelegate: [MyDelegate new]];

  return NSApplicationMain (argc, argv);
}
