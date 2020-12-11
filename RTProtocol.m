
#import "RTProtocol.h"
#import "RTMethod.h"


@interface _RTObjCProtocol : RTProtocol
{
    Protocol *_protocol;
}
@end

@implementation _RTObjCProtocol

- (id)initWithObjCProtocol: (Protocol *)protocol
{
    if((self = [self init]))
    {
        _protocol = protocol;
    }
    return self;
}

- (id)objCProtocol
{
    return _protocol;
}

@end

@implementation RTProtocol

+ (NSArray *)allProtocols
{
    unsigned int count;
    
    Protocol *__unsafe_unretained*protocols = objc_copyProtocolList(&count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [[self alloc] initWithObjCProtocol: protocols[i]]];
    
    free(protocols);
    return array;
}

+ (id)protocolWithObjCProtocol: (Protocol *)protocol
{
    return [[self alloc] initWithObjCProtocol: protocol];
}

+ (id)protocolWithName: (NSString *)name
{
    return [[self alloc] initWithName: name];
}

- (id)initWithObjCProtocol: (Protocol *)protocol
{
    
    return [[_RTObjCProtocol alloc] initWithObjCProtocol: protocol];
}

- (id)initWithName: (NSString *)name
{
    return [self initWithObjCProtocol:objc_getProtocol([name cStringUsingEncoding:[NSString defaultCStringEncoding]])];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@>", [self class], self, [self name]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [RTProtocol class]] &&
           protocol_isEqual([self objCProtocol], [other objCProtocol]);
}

- (Protocol *)objCProtocol
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSUInteger)hash
{
    return [[self objCProtocol] hash];
}

- (NSString *)name
{
    return [NSString stringWithUTF8String: protocol_getName([self objCProtocol])];
}

- (NSArray *)incorporatedProtocols
{
    unsigned int count;
    Protocol *__unsafe_unretained*protocols = protocol_copyProtocolList([self objCProtocol], &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTProtocol protocolWithObjCProtocol: protocols[i]]];
    
    free(protocols);
    return array;
}

- (NSArray *)methodsRequired: (BOOL)isRequiredMethod instance: (BOOL)isInstanceMethod
{
    unsigned int count;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList([self objCProtocol], isRequiredMethod, isInstanceMethod, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
    {
        NSString *signature = [NSString stringWithCString: methods[i].types encoding: [NSString defaultCStringEncoding]];
        [array addObject: [RTMethod methodWithSelector: methods[i].name implementation: NULL signature: signature]];
    }
    
    free(methods);
    return array;
}

@end
