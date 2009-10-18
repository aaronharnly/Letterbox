/*!
 *	@header NSObject+LetterboxSwizzle.h
 *	@abstract Some utilities for replacing methods in existing classes.
 *	@discussion 
 *    Some standard implementations of swizzling and other hackery -- 
 *    tools of the plugin writer's trade!
 *
 *  Created by Aaron Harnly on 11/4/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 *
 */ 

#import <Cocoa/Cocoa.h>

/*!
 * @category NSObject (LetterboxSwizzle)
 * @abstract Some utilities for replacing methods in existing classes.
 * @discussion 
 *  Note that the method names are prefixed with the plugin project name
 *  in order to prevent separate plugins from colliding.
 */
@interface NSObject (LetterboxSwizzle)


/*! @method Letterbox_swizzleMethod: withMethod:
 *  @abstract Swaps the implementations of two instance methods within a class.
 *  @discussion
 * Swizzling allows us to patch the behavior of an existing class by:
 *
 *		1. Creating a category on that class
 *          For example, @interface SomeWidget (Letterbox_Customizations)
 *
 *		2. Writing an instance method with the same signature as our target method
 *         For example, for the target method 
 *              -(id)foobar
 *
 *         we might write the replacement method
 *              -(id)customFoobar
 *
 *		3. Swapping the implementations of the two methods, 
 *       so that a call to 'foobar' will actually invoke our 
 *       'customizFoobar' implementation, and vice-versa.
 *
 *      We can implement the swizzle like this:
 *       [SomeWidget Letterbox_swizzleMethod:@selector(foobar) withMethod:@selector(customFoobar)];
 *
 *   To call the original foobar implementation, send a 'customFoobar' message.
 */
+ (void)Letterbox_swizzleMethod:(SEL)orig_sel withMethod:(SEL)alt_sel;

/*! @method Letterbox_swizzleClassMethod: withClassMethod:
 *  @abstract Swaps the implementations of two class methods.
 *  @discussion
 *   If you use a category to add the method customFooBar: to
 *   a class, you can then use swizzling to make all calls to
 *   fooBar: actually trigger your code in customFooBar:
 *   (and vice-versa)
 *
 *   To call the *original* fooBar: implementation, send a 'customFooBar:' message.
 */
+ (void)Letterbox_swizzleClassMethod:(SEL)orig_sel withClassMethod:(SEL)alt_sel;


/*! @method Letterbox_replaceMethod: withMethod: fromClass:
 *  @abstract Replaces the implementation of an original method fooBar:
 *  with some other method doStuff: from a different target class.
 *  @discussion 
 *   This can be used to eliminate the specialized behavior of a subclass.
 *   If for some reason you want a CustomizedWidget's 'oink' method 
 *   to behave like that of the superclass GenericWidget, you can call
 *
 *   [CustomizedWidget Letterbox_replaceMethod:@selector(oink)
 *		withMethod:@selector(oink) 
 *		fromClass:[GenericWidget class]];
 */
+ (void)Letterbox_replaceMethod:(SEL)orig_sel withMethod:(SEL)alt_sel fromClass:(Class)targetClass;


/*! @method Letterbox_addMethod: toClassNamed:
 *  @abstract Creates a new method in the target class, using an implementation from the source class.
 *  @discussion
 *   The source class is intended to be one you control, and thus can specify with an ordinary Class reference.
 *   The target class is possibly a private class; under the 64-bit dynamic loader, that class must be referenced
 *    dynamically by name, rather than with a Class reference symbol.
 * 
 */
+ (void)Letterbox_addMethod:(SEL)sel toClassNamed:(NSString *)targetClassName;

/*! @method Letterbox_addMethod: fromClassNamed:
 *  @abstract Creates a new method in the target class, using an implementation from the source class.
 *  @discussion
 *   The source class is intended a private class; that class must be referenced
 *    dynamically by name, rather than with a Class reference symbol.
 *   
 *   The target class is intended to be one you control, and thus can specify with an ordinary Class reference.
 * 
 */
+ (void)Letterbox_addMethod:(SEL)sel fromClassNamed:(NSString *)sourceClass;


/*! @method Letterbox_addClassMethod: fromClassNamed:
 *  @abstract Creates a new class method in the target class, using an implementation from the source class.
 *  @discussion
 *   The source class is intended a private class; that class must be referenced
 *    dynamically by name, rather than with a Class reference symbol.
 *   
 *   The target class is intended to be one you control, and thus can specify with an ordinary Class reference.
 * 
 */
+ (void)Letterbox_addClassMethod:(SEL)sel fromClassNamed:(NSString *)sourceClass;


/*! @method Letterbox_performSelector: asClass:
 *  @abstract Makes an object of one class run a method from a completely different class.
 *  @discussion
 *   For example, with two classes Sun and Moon, which implement sunShine: and moonShine:
 *   we can send 
 *
 *      [theSun Letterbox_performSelector:@(moonShine) asClass:[Moon class]] 
 *
 * to get a one-time novel behavior in which a Sun will shine like a Moon!
 *  
 *  Note that if moonShine references variables or methods from Moon
 *   that don't exist in Sun, the universe will explode. Use with extreme caution.
 */
- (id)Letterbox_performSelector:(SEL)sel asClass:(Class)cls;

/*! @method Letterbox_instanceID
 *  @abstract An instance method that retrieves a unique identifier for each instance of a class.
 *  @discussion
 *  Categories don't allow us to add instance variables that were not 
 *  in the original class.
 *
 *  To work around this, we generate an instance method that accesses a *class method*
 *  which stores a dictionary that maps from instances to dictionaries.
 */
- (id)Letterbox_instanceID;

/*! @method Letterbox_ivars
 *  @abstract Retrieves a dictionary that can be used to set and retrieve quasi 'instance variables'
 *            for use in a category.
 *  @discussion
 *  From any particular instance, just call 
 *   [[self Letterbox_ivars] setObject:blah forKey:@"foo"]
 *
 * and
 *  [[self Letterbox_ivars] objectForKey:@"foo"]
 *
 * to set and retrieve values.
 */
- (NSMutableDictionary *)Letterbox_ivars;
@end
