//
//  OJOClient.h
//  OJOv1
//
//  Created by MilosHavel on 05/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebClient.h"

typedef void (^WebClientOnFinish)(NSArray *);
typedef void (^WebClientOnFail)(NSError *);

@interface OJOClient : NSObject



+ (OJOClient *) sharedWebClient;

+ (void) destroyWebClient;

- (void) loginWithMethod:(NSString *) method
             andUsername:(NSString *) username
             andPassword:(NSString *) password
                onFinish:(WebClientOnFinish) finishBlock
                  onFail:(WebClientOnFail)  failBlock;

- (void) getAllUsers:(NSString *) method
            onFinish:(WebClientOnFinish) finishBlock
              onFail:(WebClientOnFail) failBlock;

- (void) getAllLocations:(NSString *) method
                onFinish:(WebClientOnFinish) finishBlock
                  onFail:(WebClientOnFail) failBlock;

- (void) getAllItems:(NSString *) method
            onFinish:(WebClientOnFinish) finishBlock
              onFail:(WebClientOnFail) failBlock;

- (void) getAllCateogories:(NSString *) method
                  onFinish:(WebClientOnFinish) finishBlock
                    onFail:(WebClientOnFail) failBlock;


- (void) saveUser:(NSString *) method
      andFullName:(NSString *) fullName
      andUsername:(NSString *) username
         andEmail:(NSString *) email
      andPassword:(NSString *) password
          andRole:(NSString *) role
      andLocation:(NSString *) location
         onFinish:(WebClientOnFinish) finishBlock
           onFail:(WebClientOnFail) failBlock;

- (void) editUser:(NSString *) method
       andOldName:(NSString *) oldName
       andNewName:(NSString *) fullName
      andUsername:(NSString *) username
         andEmail:(NSString *) email
      andPassword:(NSString *) password
          andRole:(NSString *) role
      andLocation:(NSString *) location
         onFinish:(WebClientOnFinish) finishBlock
           onFail:(WebClientOnFail) failBlock;

- (void) deleteUser:(NSString *) method
        andUsername:(NSString *) username
           onFinish:(WebClientOnFinish) finishBlock
             onFail:(WebClientOnFail) failBlock;

- (void) deleteCategory:(NSString *) method
        andCategoryName:(NSString *) categoryName
               onFinish:(WebClientOnFinish) finishBlock
                 onFail:(WebClientOnFail) failBlock;
- (void) addCategory:(NSString *) method
     andCategoryName:(NSString *) categoryName
      andFullAndOpen:(NSInteger) fullAndOpen
        andfrequency:(NSInteger) frequency
       onFinishBlock:(WebClientOnFinish) finishBlock
         onFailBlock:(WebClientOnFail) failBlock;

- (void) deleteItem:(NSString *) method
        andItemName:(NSString *) itemName
      onFinishBlock:(WebClientOnFinish) finishBlock
        onFailBlock:(WebClientOnFail) failBlock;

- (void) addItem:(NSString *) method
     andItemName:(NSString *) itemName
 andItemCategory:(NSString *) itemCategory
    andBtFullWet:(NSString *) btFullWet
     andBtEmpWet:(NSString *) btEmpWet
       andLiqWet:(NSString *) liqWet
       andServBt:(NSString *) servBt
      andServWet:(NSString *) servWet
        andPrice:(NSString *) price
   onFinishBlock:(WebClientOnFinish) finishBlock
     onFailBlock:(WebClientOnFail) failBlock;

- (void) getInventoryAllItemOfBar:(NSString *) method
          andFinishBlock:(WebClientOnFinish) finishBlock
            andFailBlock:(WebClientOnFail) failBlock;

- (void) addInventory:(NSString *) method
          andItemName:(NSString *) itemName
            andParStr:(NSString *) parStr
       andFinishBlock:(WebClientOnFinish) finishBlock
         andFailBlock:(WebClientOnFail) failBlock;



- (void) unsetInventory:(NSString *) method
            andItemName:(NSString *) itemName
         andFinishBlock:(WebClientOnFinish) finishBlock
           andFailBlock:(WebClientOnFail) failBlock;

- (void) editInventory:(NSString *) method
           andItemName:(NSString *) itemName
          andOpenBtWet:(NSString *) openBtWet
             andAmount:(NSString *) amount
              andPrice:(NSString *) price
        andFinishBlock:(WebClientOnFinish) finishBlock
          andFailBlock:(WebClientOnFail) failBlock;


- (void) editManagerInventory:(NSString *) method
                  andItemName:(NSString *) itemName
                    andAmount:(NSString *) amount
               andFinishBlock:(WebClientOnFinish) finishBlock
                 andFailBlock:(WebClientOnFail) failBlock;

- (void) addComment:(NSString *) method
    andLocationName:(NSString *) locationName
  andCommentContent:(NSString *) commentContent
     andFinishBlock:(WebClientOnFinish) finishBlock
       andFailBlock:(WebClientOnFail) failBlock;

- (void) refill:(NSString *) method
    andItemName:(NSString *) itemName
   andAddAmount:(NSString *) addAmount
 andFinishBlock:(WebClientOnFinish) finishBlock
   andFailBlock:(WebClientOnFail) failBlock;

- (void) itemMoveAllow:(NSString *) method
             andMoveID:(NSString *) moveID
       andMoveItemName:(NSString *) moveItemName
         andMoveAmount:(NSString *) moveAmount
     andSenderLocation:(NSString *) senderLocation
   andReceiverLocation:(NSString *) receiverLocation
        andFinishBlock:(WebClientOnFinish) finishBlock
          andFailBlock:(WebClientOnFail) failBlock;

- (void) itemMoveReject:(NSString *) method
              andMoveID:(NSString *) moveID
        andMoveItemName:(NSString *) moveItemName
          andMoveAmount:(NSString *) moveAmount
      andSenderLocation:(NSString *) senderLocation
    andReceiverLocation:(NSString *) receiverLocation
         andFinishBlock:(WebClientOnFinish) finishBlock
           andFailBlock:(WebClientOnFail) failBlock;

- (void) managerItemMove:(NSString *) method
         andMoveItemName:(NSString *) moveItemName
           andMoveAmount:(NSString *) moveAmount
       andSenderLocation:(NSString *) senderLocation
     andReceiverLocation:(NSString *) receiverLocation
            andSenderName:(NSString *) senderName
          andFinishBlock:(WebClientOnFinish) finishBlock
            andFailBlock:(WebClientOnFail) failBlock;

- (void) searchReceiveItem:(NSString *) method
        andReceiveLocation:(NSString *) locationName
            andFinishBlock:(WebClientOnFinish) finishBlock
              andFailBlock:(WebClientOnFail) failBlock;

- (void) searchReceiveItemAtLocation:(NSString *) method
                      andFinishBlock:(WebClientOnFinish) finishBlock
                        andFailBlock:(WebClientOnFail) failBlock;

- (void) changeAdminPassword:(NSString *) method
                 andUsername:(NSString *) username
              andOldPassword:(NSString *) oldPassword
              andNewPassword:(NSString *) newPassword
                    onFinish:(WebClientOnFinish) finishBlock
                      onFail:(WebClientOnFail) failBlock;

- (void) setSequence:(NSString *) method
       andJsonString:(NSString *) jsonString
            onFinish:(WebClientOnFinish) finishBlock
              onFail:(WebClientOnFail) failBlock;

- (void) searchTodayMovedItem:(NSString *) method
                andDateString:(NSString *) dateStr
                     onFinish:(WebClientOnFinish) finishBlock
                       onFail:(WebClientOnFail) failBlock;



- (void) searchUnreportedItems:(NSString *) method
                   andLocation:(NSString *) location
                andFinishBlock:(WebClientOnFinish) finishBlock
                  andFailBlock:(WebClientOnFail) failBlock;


- (void) updateUnreportedItem:(NSString *) method
                 andMovedInID:(NSString *) movedInID
                andMovedOutID:(NSString *) movedOutID
                  andLocation:(NSString *) location
               andFinishBlock:(WebClientOnFinish) finishBlock
                 andFailBlock:(WebClientOnFail) failBlock;

- (void) itemLocationStatusUpdate:(NSString *) method
                        andStatus:(NSString *) status
                      andItemName:(NSString *) itemName
                  andLocationName:(NSString *) locationName
                           andPar:(NSString *)par
                   andFinishBlock:(WebClientOnFinish) finishBlock
                      andFailBock:(WebClientOnFail) failBlock;



@end
