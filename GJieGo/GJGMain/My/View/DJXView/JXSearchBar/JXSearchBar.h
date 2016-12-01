//
//  JXSearchBar.h
//  JXView
//
//  Created by dujinxin on 15-3-5.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXSearchBarDelegate;

//A clean, easy to use, awesome replacement for UISearchBar.
@interface JXSearchBar : UIView

//Wrappers around the Textfield subview
@property (nonatomic) NSString *text;
@property (nonatomic) UIFont *font;
@property (nonatomic) NSString *placeholder;

//The text field subview
@property (nonatomic) UITextField *textField;

@property (nonatomic, getter = isCancelButtonHidden) BOOL cancelButtonHidden; //NO by Default

@property (nonatomic, weak) id <JXSearchBarDelegate> delegate;

@end

@protocol JXSearchBarDelegate <NSObject>

@optional
- (void)searchBarCancelButtonClicked:(JXSearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(JXSearchBar *)searchBar;

- (BOOL)searchBarShouldBeginEditing:(JXSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(JXSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(JXSearchBar *)searchBar;

- (void)searchBar:(JXSearchBar *)searchBar textDidChange:(NSString *)searchText;
@end

//A rounded view that makes up the background of the search bar.
@interface SSRoundedView : UIView
@end
