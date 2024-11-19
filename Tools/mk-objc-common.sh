to_camel_name () {
  echo "$(echo "$1" | sed -r 's/(^|-)(\w)/\U\2/g')"
}

to_header_marker () {
  echo "_$(echo "$class_name" | tr '[a-z]' '[A-Z]')_H_"
}

emacs_marker () {
  echo "// -*- mode: ObjC -*-"
}

vim_marker () {
  echo "// vim: filetype=objc ts=2 sw=2 expandtab"
}

make_header() {
local class_name="$(to_camel_name $1)"
local header_name="$(to_header_marker $class_name)"
cat << EOF_H
$(emacs_marker)
#ifndef $header_name
#define $header_name

#import <Foundation/Foundation.h>

@interface $class_name : NSObject
{
  NSString *_name;
}
- (instancetype) init;
- (void) dealloc;
- (NSString *) name;
- (void) setName: (NSString *)name;
@end

#endif
$(vim_marker)
EOF_H
}

make_source () {
class_name="$(to_camel_name $1)"

cat << EOF_S
$(emacs_marker)
#import <Foundation/Foundation.h>
#import "$class_name.h"

@implementation $class_name
- (instancetype) init
{
  if ((self = [super init]) != nil)
    {
      // implement hear
    }
  return self;
}

- (void) dealloc
{
  RELEASE(_name);
  [super dealloc];
}

- (NSString *)name
{
  return _name;
}

- (void) setName: (NSString *)name
{
  ASSIGNCOPY(_name, name);
}

@end

$(vim_marker)
EOF_S
}
