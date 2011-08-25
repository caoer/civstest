/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "NSArray+UtilityExtensions.h"
#import "NSObject+UtilityExtensions.h"
#import <time.h>
#import <stdarg.h>

/*
 Thanks to August Joki, Emanuele Vulcano, BlueLlama, Optimo, jtbandes
 
 To add Math Extensions like sum, product?
 */

// Unbiased random rounding thingy. TODO: Use Arc4Random
//static NSUInteger random_below(NSUInteger n)
//{
//    NSUInteger m = 1;
//	
//    do
//	{
//        m <<= 1;
//    }
//	while(m < n);
//	
//    NSUInteger ret;
//	
//    do
//	{
//        ret = random() % m;
//    }
//	while(ret >= n);
//	
//    return ret;
//}


#pragma mark StringExtensions
@implementation NSArray (StringExtensions)
- (NSArray *) arrayBySortingStrings
{
	NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
	for (id eachitem in self)
		if (![eachitem isKindOfClass:[NSString class]])	[sort removeObject:eachitem];
	return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSString *) stringValue
{
	return [self componentsJoinedByString:@" "];
}
@end

#pragma mark UtilityExtensions
@implementation NSArray (UtilityExtensions)
- (id) firstObject
{
	return [self objectAtIndex:0];
}

- (NSArray *) uniqueMembers
{
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
	{
		[copy removeObjectIdenticalTo:object];
		[copy addObject:object];
	}
	return [copy autorelease];
}

- (NSArray *) unionWithArray: (NSArray *) anArray
{
	if (!anArray) return self;
	return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}

- (NSArray *) intersectionWithArray: (NSArray *) anArray
{
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
		if (![anArray containsObject:object]) 
			[copy removeObjectIdenticalTo:object];
    NSArray *result = [copy uniqueMembers];
    [copy release];
	return result;
}

// A la LISP, will return an array populated with values
- (NSArray *) map: (SEL) selector withObject: (id) object1 withObject: (id) object2
{
	NSMutableArray *results = [NSMutableArray array];
	for (id eachitem in self)
	{
		if (![eachitem respondsToSelector:selector])
		{
			[results addObject:[NSNull null]];
			continue;
		}
		
		id riz = [eachitem objectByPerformingSelector:selector withObject:object1 withObject:object2];
		if (riz)
			[results addObject:riz];
		else
			[results addObject:[NSNull null]];
	}
	return results;
}

- (NSArray *) map: (SEL) selector withObject: (id) object1
{
	return [self map:selector withObject:object1 withObject:nil];
}

- (NSArray *) map: (SEL) selector
{
	return [self map:selector withObject:nil];
}


// NOTE: Selector must return BOOL
- (NSArray *) collect: (SEL) selector withObject: (id) object1 withObject: (id) object2
{
	NSMutableArray *riz = [NSMutableArray array];
	for (id eachitem in self)
	{
		BOOL yorn;
		NSValue *eachriz = [eachitem valueByPerformingSelector:selector withObject:object1 withObject:object2];
		if (strcmp([eachriz objCType], "c") == 0) 
		{
			[eachriz getValue:&yorn];
			if (yorn) [riz addObject:eachitem];
		}
	}
	return riz;
}

- (NSArray *) collect: (SEL) selector withObject: (id) object1
{
	return [self collect:selector withObject:object1 withObject:nil];
}

- (NSArray *) collect: (SEL) selector
{
	return [self collect:selector withObject:nil withObject:nil];
}

// NOTE: Selector must return BOOL
- (NSArray *) reject: (SEL) selector withObject: (id) object1 withObject: (id) object2
{
	NSMutableArray *riz = [NSMutableArray array];
	for (id eachitem in self)
	{
		BOOL yorn;
		NSValue *eachriz = [eachitem valueByPerformingSelector:selector withObject:object1 withObject:object2];
		if (strcmp([eachriz objCType], "c") == 0) 
		{
			[eachriz getValue:&yorn];
			if (!yorn) [riz addObject:eachitem];
		}
	}
	return riz;
}

- (NSArray *) reject: (SEL) selector withObject: (id) object1
{
	return [self reject:selector withObject:object1 withObject:nil];
}

- (NSArray *) reject: (SEL) selector
{
	return [self reject:selector withObject:nil withObject:nil];
}

- (int *) arrayOfInts
{
    NSInteger count = [self count];
    int *array = malloc(sizeof(id *) * count);
    for (int i = 0; i < count; ++i)
    {
        array[i] = [[self objectAtIndex:i] intValue];
    }
    return array;
}

@end

#pragma mark Mutable UtilityExtensions
@implementation NSMutableArray (UtilityExtensions)
//NSInteger myCompare(id item1, id item2, void *context)
//{
//    return [(NSString *)item1 localizedCaseInsensitiveCompare:(NSString *)item2];
//}
//-(void)addItem:(NSString *)aItem
//{
//    [self addObject:aItem];
//    NSArray *temp = [NSArray arrayWithArray:self];
//    self = [NSMutableArray arrayWithArray:[temp sortedArrayUsingFunction:myCompare context:NULL]];
//}
- (NSMutableArray *) reverse
{
	for (int i=0; i<(floor([self count]/2.0)); i++) 
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
	return self;
}

// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMutableArray *) scramble
{
	for (int i=0; i<([self count]-2); i++) 
		[self exchangeObjectAtIndex:i withObjectAtIndex:(i+(arc4random()%([self count]-i)))];
	return self;
}

//NOTE: Not part of the original extension
- (void)shuffle
{
//    // http://en.wikipedia.org/wiki/Knuth_shuffle
//	
//    for(NSUInteger i = [self count]; i > 1; i--)
//	{
//        NSUInteger j = random_below(i);
//        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
//    }
    //http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (NSMutableArray *) removeFirstObject
{
	[self removeObjectAtIndex:0];
	return self;
}
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
        [obj retain];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
        [obj release];
    }
}
@end


#pragma mark StackAndQueueExtensions
@implementation NSMutableArray (StackAndQueueExtensions)
- (id) popObject
{
	if ([self count] == 0) return nil;
	
    id lastObject = [[[self lastObject] retain] autorelease];
    [self removeLastObject];
    return lastObject;
}

- (NSMutableArray *) pushObject:(id)object
{
    [self addObject:object];
	return self;
}

- (NSMutableArray *) pushObjects:(id)object,...
{
	if (!object) return self;
	id obj = object;
	va_list objects;
	va_start(objects, object);
	do 
	{
		[self addObject:obj];
		obj = va_arg(objects, id);
	} while (obj);
	va_end(objects);
	return self;
}

- (id) pullObject
{
	if ([self count] == 0) return nil;
	
	id firstObject = [[[self objectAtIndex:0] retain] autorelease];
	[self removeObjectAtIndex:0];
	return firstObject;
}

- (NSMutableArray *)push:(id)object
{
	return [self pushObject:object];
}

- (id) pop
{
	return [self popObject];
}

- (id) pull
{
	return [self pullObject];
}
@end