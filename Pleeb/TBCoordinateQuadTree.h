//
//  TBCoordinateQuadTree.h
//  LIVV

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>


#import "TBQuadTree.h"

@interface TBCoordinateQuadTree : NSObject

@property (assign, nonatomic) TBQuadTreeNode* root;
@property (strong, nonatomic) MKMapView *mapView;

- (void)buildTree;
- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;

@end
