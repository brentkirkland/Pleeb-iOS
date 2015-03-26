//
//  TBClusterAnnotationView.h
//  Pleeb
//
//  Created by Theodore Calmes on 10/4/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TBClusterAnnotationView : MKAnnotationView

@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) BOOL isParty;

@end
