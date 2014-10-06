//
//  PageingDelegate.h
//  ZHGreenFuture
//
//  Created by elvis on 10/6/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#ifndef ZHGreenFuture_PageingDelegate_h
#define ZHGreenFuture_PageingDelegate_h

@protocol PageingDelegate <NSObject>

-(BOOL)isLastPage;
-(NSInteger)currentPage;

-(void)setCurrentPage:(NSInteger)page;
-(void)setLastPage:(BOOL)bLastPage;

-(void)appendData:(NSArray*)data;
-(void)setData:(NSArray*)data;

-(NSArray*)datas;
@end


#endif
