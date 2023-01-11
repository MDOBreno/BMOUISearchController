//
//  ViewController.m
//  BMOUISearchController
//
//  Created by BRENOMEDEIROS on 29/12/22.
//

#import "ViewController.h"

@interface ViewController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    UISearchController* searchController;
    NSMutableArray<NSString*>* originalDataSource;
    
    NSMutableArray<NSString*>* currentDataSource;
}

@end




@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    originalDataSource = [NSMutableArray arrayWithObjects: nil];
    currentDataSource = [NSMutableArray arrayWithObjects: nil];
    
    
    [self addProductToDataSourceWithProductCount:[NSNumber numberWithInt:25] andProduct:@"Macbook Pro 15"];
    [self addProductToDataSourceWithProductCount:[NSNumber numberWithInt:20] andProduct:@"Macbook Air"];
    [self addProductToDataSourceWithProductCount:[NSNumber numberWithInt:30] andProduct:@"Macbook"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    currentDataSource = originalDataSource;
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.obscuresBackgroundDuringPresentation = false;
    [_searchContainerView addSubview:searchController.searchBar];
    searchController.searchBar.delegate = self;
}

-(void) addProductToDataSourceWithProductCount:(NSNumber *)productCount andProduct:(NSString *) product {
    
    for (NSNumber * index=[NSNumber numberWithInt:1]; index<productCount; index = [NSNumber numberWithInt:[index intValue] + 1]) {
        [originalDataSource addObject:[NSString stringWithFormat:@"%@ #%@", product, index]];
    }
}

-(void) filterCurrentDataSourceWith:(NSString *)searchTerm {
    if ([searchTerm length] > 0) {
        currentDataSource = originalDataSource;
        //NSMutableArray<NSString*>* filteredResults = (NSMutableArray<NSString*>*) [currentDataSource filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF like[c] %@", [NSString stringWithFormat:@"*%@*",searchTerm]]];
        NSMutableArray<NSString*>* filteredResults = (NSMutableArray<NSString*>*) [currentDataSource filteredArrayUsingPredicate:
                                                      [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *d) {
                                                          return ( ([ [ ((NSString *)obj) stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                                     rangeOfString: [ searchTerm stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                                     options:NSCaseInsensitiveSearch
                                                                    ].location != NSNotFound)  );
                                                      }
                                                  ]];
        currentDataSource = filteredResults;
        [_tableView reloadData];
    }
}

-(void) restoreCurrentDataSource {
    currentDataSource = originalDataSource;
    [_tableView reloadData];
}

- (IBAction)restoreData:(id)sender {
    [self restoreCurrentDataSource];
}


#pragma mark - Extensao para implementar o protocolo UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController { 
    if ([searchController.searchBar.text length] > 0) {
        NSString *searchText = searchController.searchBar.text;
        [self filterCurrentDataSourceWith:searchText];
    }
}

#pragma mark - Extensao para implementar o protocolo UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchController.active = false;
    
    if ([searchBar.text length] > 0) {
        NSString *searchText = searchBar.text;
        [self filterCurrentDataSourceWith:searchText];
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchController.active = false;
    
    if ( [searchBar.text length] > 0)  {
        NSString *searchText = searchBar.text;
        
        [self restoreCurrentDataSource];
    }
}

#pragma mark - Extensao para implementar os protocolos UITableViewDataSource e UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Selection" message:[NSString stringWithFormat:@"Selected: %@", currentDataSource[indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
    
    searchController.active = false;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = currentDataSource[indexPath.row];
    return cell;
}

@end



