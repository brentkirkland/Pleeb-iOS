//
//  TBClusterAnnotationView.h
//  LIVV

#import <MapKit/MapKit.h>
#import "TBClusterAnnotation.h"

@interface TBClusterAnnotationView : MKAnnotationView


@property (assign, nonatomic) NSUInteger count;

@property (assign, nonatomic) NSUInteger weight;

@property (assign, nonatomic) BOOL isParty;

@property (strong, nonatomic) UILabel *countLabel;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCount:(NSUInteger)count;

@end
