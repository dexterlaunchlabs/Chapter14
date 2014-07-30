//
//  BIDMasterViewController.m
//  TinyPix
//
//  Created by Dexter Launchlabs on 7/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "BIDMasterViewController.h"

#import "BIDDetailViewController.h"
#import "BIDTinyPixDocument.h"
@interface BIDMasterViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) NSArray *documentFilenames;
@property (strong, nonatomic) BIDTinyPixDocument *chosenDocument;
- (NSURL *)urlForFilename:(NSString *)filename;
- (void)reloadFiles;

@end

@implementation BIDMasterViewController
@synthesize colorControl;
@synthesize documentFilenames;
@synthesize chosenDocument;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                               action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton; [self reloadFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject { // get the name
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"Filename"
                               message:@"Enter a name for your new TinyPix document." delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Create", nil]; alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show]; }

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.documentFilenames count];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell"];
    NSString *path = [self.documentFilenames objectAtIndex:indexPath.row]; cell.textLabel.text = path.lastPathComponent.stringByDeletingPathExtension; return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { if (sender == self) {
    // if sender == self, a new document has just been created, // and chosenDocument is already set.
    UIViewController *destination = segue.destinationViewController; if ([destination respondsToSelector:@selector(setDetailItem:)]) {
        [destination setValue:self.chosenDocument forKey:@"detailItem"]; }
} else {
    // find the chosen document from the tableview
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow]; NSString *filename = [documentFilenames objectAtIndex:indexPath.row]; NSURL *docUrl = [self urlForFilename:filename];
    self.chosenDocument = [[BIDTinyPixDocument alloc] initWithFileURL:docUrl]; [self.chosenDocument openWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"load OK");
            UIViewController *destination = segue.destinationViewController; if ([destination respondsToSelector:@selector(setDetailItem:)]) {
                [destination setValue:self.chosenDocument forKey:@"detailItem"]; }
        } else {
            NSLog(@"failed to load!");
        } }];
} }
- (NSURL *)urlForFilename:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename]; NSURL *url = [NSURL fileURLWithPath:filePath];
    return url;
}
- (void)reloadFiles {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0]; NSFileManager *fm = [NSFileManager defaultManager];
    NSError *dirError;
    NSArray *files = [fm contentsOfDirectoryAtPath:path error:&dirError]; if (!files) {
        NSLog(@"Encountered error while trying to list files in directory %@: %@", path, dirError);
    }
    NSLog(@"found files: %@", files);
    files = [files sortedArrayUsingComparator: ^NSComparisonResult(id filename1, id filename2) {
        NSDictionary *attr1 = [fm attributesOfItemAtPath:
                               [path stringByAppendingPathComponent:filename1]
                                                   error:nil]; NSDictionary *attr2 = [fm attributesOfItemAtPath:
                                                                                      [path stringByAppendingPathComponent:filename2] error:nil];
        return [[attr2 objectForKey:NSFileCreationDate] compare: [attr1 objectForKey:NSFileCreationDate]];
    }];
    self.documentFilenames = files; [self.tableView reloadData];
}
- (IBAction)chooseColor:(id)sender {
    NSInteger selectedColorIndex = [(UISegmentedControl *)sender selectedSegmentIndex]; NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:selectedColorIndex forKey:@"selectedColorIndex"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger selectedColorIndex = [prefs integerForKey:@"selectedColorIndex"]; self.colorControl.selectedSegmentIndex = selectedColorIndex;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *filename = [NSString stringWithFormat:@"%@.tinypix",
                              [alertView textFieldAtIndex:0].text]; NSURL *saveUrl = [self urlForFilename:filename];
        self.chosenDocument = [[BIDTinyPixDocument alloc] initWithFileURL:saveUrl]; [chosenDocument saveToURL:saveUrl
                                                                                             forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                                                                                                 if (success) {
                                                                                                     NSLog(@"save OK");
                                                                                                     [self reloadFiles];
                                                                                                     [self performSegueWithIdentifier:@"masterToDetail" sender:self];
                                                                                                 } else {
                                                                                                     NSLog(@"failed to save!");
                                                                                                 } }];
    } }
@end
