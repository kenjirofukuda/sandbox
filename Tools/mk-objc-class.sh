#!/usr/bin/env sh
if [ $# -eq 0 ]; then
    read -p "Enter class name: " class_name
else
    class_name="$1"
fi
class_name=$(echo "$class_name" | sed -r 's/(^|-)(\w)/\U\2/g')
header_name="_$(echo "$class_name" | tr '[a-z]' '[A-Z]')_H_"
cat << EOF_H
#ifndef $header_name
#define $header_name

#import <Foundation/Foundation.h>
@class $class_name : NSObject
{
  (NSString *) _name;
}
- (instancetype) init;
- (void) dealloc;
#endif
EOF_H
