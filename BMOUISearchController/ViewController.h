//
//  ViewController.h
//  BMOUISearchController
//
//  Created by BRENOMEDEIROS on 29/12/22.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UISearchResultsUpdating>


@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

