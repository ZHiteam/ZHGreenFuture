//
//  FEStrikeThroughLabel.h
//  StrikeThroughLabel
//
//  Created by admin on 14-9-15.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    FEStrikeThroughMiddleStyle,
    FEStrikeThroughBottomStyle
}FEStrikeThroughStyle;

@interface FEStrikeThroughLabel : UILabel
@property (nonatomic, assign) BOOL                     strikeThroughEnabled;
@property (nonatomic, assign) FEStrikeThroughStyle     style;
@end
