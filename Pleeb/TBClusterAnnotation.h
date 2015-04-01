//
//  TBClusterAnnotation.h
//  LIVV

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface TBClusterAnnotation : NSObject <MKAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger weight;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count weight:(NSInteger)weight;

@end
