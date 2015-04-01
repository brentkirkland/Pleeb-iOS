//
//  TBClusterAnnotation.m
//  LIVV

#import "TBClusterAnnotation.h"

@implementation TBClusterAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count weight:(NSInteger)weight
{
    self = [super init];
    
    if (self) {
        _coordinate = coordinate;
        _title = [NSString stringWithFormat:@"%lu events in this area", count];
        _count = count;
        _weight = weight;
    }
    return self;
}

- (NSUInteger)hash
{
    NSString *toHash = [NSString stringWithFormat:@"%.5F%.5F", self.coordinate.latitude, self.coordinate.longitude];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object
{
    return [self hash] == [object hash];
}

@end
