//
//  OJOClient.m
//  OJOv1
//
//  Created by MilosHavel on 05/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "OJOClient.h"
#import "define.h"
static OJOClient *webClient = nil;

@implementation OJOClient

+ (OJOClient *) sharedWebClient {
    if (webClient == nil) {
        webClient = [[OJOClient alloc] init];
    }
    
    return webClient;
    
}

+ (void) destroyWebClient{
    webClient = nil;
}

#pragma mark - login interface


- (void) loginWithMethod:(NSString *) method
             andUsername:(NSString *) username
             andPassword:(NSString *) password
                onFinish:(WebClientOnFinish) finishBlock
                  onFail:(WebClientOnFail)  failBlock{
    NSDictionary *dictParam = @{USERNAME : username, PASSWORD : password};
    NSString *postUrl = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:postUrl parameters:dictParam suceess:^(NSArray *response) {
        finishBlock(response);
        
    } failure:^(NSError *error) {
        failBlock(error);
        
    }];
    
}


#pragma mark - Admin panal : Get all users saved on database

- (void) getAllUsers:(NSString *) method
            onFinish:(WebClientOnFinish) finishBlock
              onFail:(WebClientOnFail) failBlock{
    NSString *getAllUsersUrl = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:getAllUsersUrl parameters:nil suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];

}

#pragma mark - Admin panel : Change password

- (void) changeAdminPassword:(NSString *) method
                 andUsername:(NSString *) username
              andOldPassword:(NSString *) oldPassword
              andNewPassword:(NSString *) newPassword
                    onFinish:(WebClientOnFinish) finishBlock
                      onFail:(WebClientOnFail) failBlock{
    NSString *changePasswordURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dictParam = @{USERNAME : username, OLD_PASS : oldPassword, NEW_PASS : newPassword};
    [WebClient requestPostUrl:changePasswordURL
                   parameters:dictParam
                      suceess:^(NSArray *response) {
                          finishBlock(response);
        }
                      failure:^(NSError *error) {
                          if (failBlock) {
                              failBlock(error);
                          }
    }];
    
}

#pragma mark - Admin panel : Get all location bar saved on database


- (void) getAllLocations:(NSString *) method
                onFinish:(WebClientOnFinish) finishBlock
                  onFail:(WebClientOnFail) failBlock{
    NSString *getAllLocationURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:getAllLocationURL parameters:nil suceess:^(NSArray *response) {
       finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}

- (void) getAllItems:(NSString *) method
            onFinish:(WebClientOnFinish) finishBlock
              onFail:(WebClientOnFail) failBlock{
    NSString *getAllItemURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:getAllItemURL parameters:nil suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}

- (void) getAllCateogories:(NSString *) method
                  onFinish:(WebClientOnFinish) finishBlock
                    onFail:(WebClientOnFail) failBlock{
    NSString *getAllCategoryURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:getAllCategoryURL parameters:nil suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock){
            failBlock(error);
        }
    }];
}

- (void) saveUser:(NSString *) method
      andFullName:(NSString *) fullName
      andUsername:(NSString *) username
         andEmail:(NSString *) email
      andPassword:(NSString *) password
          andRole:(NSString *) role
      andLocation:(NSString *) location
         onFinish:(WebClientOnFinish) finishBlock
           onFail:(WebClientOnFail) failBlock {
    NSString *saveUserURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dictParam = @{NAME : fullName,
                                USERNAME : username,
                                EMAIL : email,
                                PASSWORD : password,
                                ROLE : role,
                                LOCATION : location};
    [WebClient requestPostUrl:saveUserURL parameters:dictParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}

- (void) editUser:(NSString *) method
       andOldName:(NSString *) oldName
      andNewName:(NSString *) fullName
      andUsername:(NSString *) username
         andEmail:(NSString *) email
      andPassword:(NSString *) password
          andRole:(NSString *) role
      andLocation:(NSString *) location
         onFinish:(WebClientOnFinish) finishBlock
           onFail:(WebClientOnFail) failBlock{
    NSString *saveUserURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dictParam = @{NAME : oldName,
                                NEW_NAME : fullName,
                                USERNAME : username,
                                EMAIL : email,
                                PASSWORD : password,
                                ROLE : role,
                                LOCATION : location};
    [WebClient requestPostUrl:saveUserURL parameters:dictParam
                      suceess:^(NSArray *response) {
        finishBlock(response);
    }
                      failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}

- (void) deleteUser:(NSString *) method
        andUsername:(NSString *) username
           onFinish:(WebClientOnFinish) finishBlock
             onFail:(WebClientOnFail) failBlock{
    NSString *userDeleteURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dictParam = @{USERNAME : username};
    [WebClient requestPostUrl:userDeleteURL parameters:dictParam
                      suceess:^(NSArray *response) {
                          finishBlock(response);
        
    }
                      failure:^(NSError *error) {
                          if (failBlock) {
                              failBlock(error);
                          }
        
    }];
}

- (void) deleteCategory:(NSString *)method
        andCategoryName:(NSString *)categoryName
               onFinish:(WebClientOnFinish)finishBlock
                 onFail:(WebClientOnFail)failBlock{
    NSString *categoryDeleteURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dictParam = @{CATEGORY_NAME : categoryName};
    [WebClient requestPostUrl:categoryDeleteURL
                   parameters:dictParam
                      suceess:^(NSArray *response) {
                          finishBlock(response);
        
    } failure:^(NSError *error) {
        
        if (failBlock){
            failBlock(error);
        }
        
    }];
}

- (void) addCategory:(NSString *) method
     andCategoryName:(NSString *) categoryName
      andFullAndOpen:(NSInteger) fullAndOpen
        andfrequency:(NSInteger) frequency
         onFinishBlock:(WebClientOnFinish) finishBlock
         onFailBlock:(WebClientOnFail) failBlock{
    
    NSDictionary *dictParam = @{CATEGORY_NAME : categoryName,
                                    FULL_OPEN : [NSString stringWithString:[NSString stringWithFormat:@"%ld", (long)fullAndOpen]],
                                    FREQUENCY : [NSString stringWithString:[NSString stringWithFormat:@"%ld", (long)frequency]]};
    NSString *categoryAddURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:categoryAddURL parameters:dictParam suceess:^(NSArray *response) {
            finishBlock(response);
        
    } failure:^(NSError *error) {
        if (failBlock){
            failBlock(error);
        }
        
    }];

}

- (void) deleteItem:(NSString *)method
        andItemName:(NSString *)itemName
      onFinishBlock:(WebClientOnFinish)finishBlock
        onFailBlock:(WebClientOnFail)failBlock{
    NSDictionary *dicParam = @{ITEM_NAME : itemName};
    NSString *itemDeleteURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    
    [WebClient requestPostUrl:itemDeleteURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
        
    }];

}

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
     onFailBlock:(WebClientOnFail) failBlock{
    NSDictionary *dicParam = @{ITEM_NAME : itemName,
                               ITEM_CATEGORY : itemCategory,
                               BT_FULL_WET : btFullWet,
                               BT_EMP_WET : btEmpWet,
                               LIQ_WET : liqWet,
                               SERVE_BOTTLE : servBt,
                               SERVE_WET : servWet,
                               PRICE : price};
    NSString *addItemURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    
    [WebClient requestPostUrl:addItemURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}


- (void) getInventoryAllItemOfBar:(NSString *) method
          andFinishBlock:(WebClientOnFinish) finishBlock
            andFailBlock:(WebClientOnFail) failBlock{

    NSString *addItemOfBarURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];    
    [WebClient requestPostUrl:addItemOfBarURL parameters:nil suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
        
    }];
}

- (void) addInventory:(NSString *) method
          andItemName:(NSString *) itemName
            andParStr:(NSString *) parStr
       andFinishBlock:(WebClientOnFinish) finishBlock
         andFailBlock:(WebClientOnFail) failBlock{
    NSString *addInventoryURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{INVENTORY_ITEM_NAME : itemName, INVENTORY_PAR : parStr};
    
    [WebClient requestPostUrl:addInventoryURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
        
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}

- (void) unsetInventory:(NSString *) method
            andItemName:(NSString *) itemName
         andFinishBlock:(WebClientOnFinish) finishBlock
           andFailBlock:(WebClientOnFail) failBlock{
    NSString *unsetInventoryURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{INVENTORY_ITEM_NAME : itemName};
    
    [WebClient requestPostUrl:unsetInventoryURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];

}


- (void) editInventory:(NSString *) method
           andItemName:(NSString *) itemName
          andOpenBtWet:(NSString *) openBtWet
             andAmount:(NSString *) amount
              andPrice:(NSString *) price
        andFinishBlock:(WebClientOnFinish) finishBlock
          andFailBlock:(WebClientOnFail) failBlock{
    NSString *editInventoryURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{INVENTORY_ITEM_NAME : itemName, INVENTORY_OPEN_BOTTLE_WET : openBtWet, INVENTORY_AMOUNT : amount, PRICE : price};
    
    [WebClient requestPostUrl:editInventoryURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}

- (void) editManagerInventory:(NSString *) method
                  andItemName:(NSString *) itemName
                    andAmount:(NSString *) amount
               andFinishBlock:(WebClientOnFinish) finishBlock
                 andFailBlock:(WebClientOnFail) failBlock{
    
    NSString *editManagerURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{INVENTORY_ITEM_NAME : itemName, INVENTORY_AMOUNT : amount};
    
    [WebClient requestPostUrl:editManagerURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}

- (void) addComment:(NSString *) method
    andLocationName:(NSString *) locationName
  andCommentContent:(NSString *) commentContent
     andFinishBlock:(WebClientOnFinish) finishBlock
       andFailBlock:(WebClientOnFail) failBlock{
    
    NSString *addCommentURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{LOCATION : locationName, COMMENT : commentContent};
    
    [WebClient requestPostUrl:addCommentURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}

- (void) refill:(NSString *) method
    andItemName:(NSString *) itemName
   andAddAmount:(NSString *) addAmount
 andFinishBlock:(WebClientOnFinish) finishBlock
   andFailBlock:(WebClientOnFail) failBlock{
    
    NSString *refillURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{ITEM_NAME : itemName, INVENTORY_AMOUNT : addAmount};
    
    [WebClient requestPostUrl:refillURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}


- (void) itemMoveAllow:(NSString *) method
             andMoveID:(NSString *) moveID
       andMoveItemName:(NSString *) moveItemName
         andMoveAmount:(NSString *) moveAmount
     andSenderLocation:(NSString *) senderLocation
   andReceiverLocation:(NSString *) receiverLocation
        andFinishBlock:(WebClientOnFinish) finishBlock
          andFailBlock:(WebClientOnFail) failBlock{
    
    NSString *itemMoveAllowURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{MOVE_ID : moveID, MOVE_ITEM_NAME : moveItemName, MOVE_ITEM_AMOUNT : moveAmount, SENDER_LOCATION : senderLocation, RECEIVER_LOCATION : receiverLocation};
    [WebClient requestPostUrl:itemMoveAllowURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
    
}

- (void) itemMoveReject:(NSString *) method
              andMoveID:(NSString *) moveID
        andMoveItemName:(NSString *) moveItemName
          andMoveAmount:(NSString *) moveAmount
      andSenderLocation:(NSString *) senderLocation
    andReceiverLocation:(NSString *) receiverLocation
         andFinishBlock:(WebClientOnFinish) finishBlock
           andFailBlock:(WebClientOnFail) failBlock{
    
    NSString *itemMoveRejectURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{MOVE_ID : moveID, MOVE_ITEM_NAME : moveItemName, MOVE_ITEM_AMOUNT : moveAmount, SENDER_LOCATION : senderLocation, RECEIVER_LOCATION : receiverLocation};
    [WebClient requestPostUrl:itemMoveRejectURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];



}

- (void) managerItemMove:(NSString *) method
         andMoveItemName:(NSString *) moveItemName
           andMoveAmount:(NSString *) moveAmount
       andSenderLocation:(NSString *) senderLocation
     andReceiverLocation:(NSString *) receiverLocation
           andSenderName:(NSString *) senderName
          andFinishBlock:(WebClientOnFinish) finishBlock
            andFailBlock:(WebClientOnFail) failBlock{
    NSString *itemMoveURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{MOVE_ITEM_NAME : moveItemName, MOVE_ITEM_AMOUNT : moveAmount, SENDER_LOCATION : senderLocation, RECEIVER_LOCATION : receiverLocation, SENDER_NAME : senderName};
    [WebClient requestPostUrl:itemMoveURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}

- (void) searchReceiveItem:(NSString *) method
        andReceiveLocation:(NSString *) locationName
            andFinishBlock:(WebClientOnFinish) finishBlock
              andFailBlock:(WebClientOnFail) failBlock{
    NSString *searchItemURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    NSDictionary *dicParam = @{LOCATION : locationName};
    [WebClient requestPostUrl:searchItemURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
        
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}

- (void) searchReceiveItemAtLocation:(NSString *) method
                      andFinishBlock:(WebClientOnFinish) finishBlock
                        andFailBlock:(WebClientOnFail) failBlock{
    NSString *searchItemURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:searchItemURL parameters:nil suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
    }];
}

- (void) setSequence:(NSString *) method
       andJsonString:(NSString *) jsonString
            onFinish:(WebClientOnFinish) finishBlock
              onFail:(WebClientOnFail) failBlock{
    
    NSDictionary *dicParam = @{INVENTORY_JSON : jsonString};
    NSString *setSequence = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:setSequence parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}

- (void) searchTodayMovedItem:(NSString *) method
                andDateString:(NSString *) dateStr
                     onFinish:(WebClientOnFinish) finishBlock
                       onFail:(WebClientOnFail) failBlock{
    NSDictionary *dicParam = @{DATE_STR : dateStr};
    NSString *searchURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    [WebClient requestPostUrl:searchURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if(failBlock){
            failBlock(error);
        }
        
    }];
}

- (void) searchUnreportedItems:(NSString *) method
                   andLocation:(NSString *) location
                andFinishBlock:(WebClientOnFinish) finishBlock
                  andFailBlock:(WebClientOnFail) failBlock {
    
    
    NSDictionary *dicParam = @{LOCATION : location};
    NSString *searchURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    
    [WebClient requestPostUrl:searchURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}


- (void) updateUnreportedItem:(NSString *) method
                    andMovedInID:(NSString *) movedInID
                andMovedOutID:(NSString *) movedOutID
                  andLocation:(NSString *) location
               andFinishBlock:(WebClientOnFinish) finishBlock
                 andFailBlock:(WebClientOnFail) failBlock{
    
    NSDictionary *dicParam = @{MOVED_IN_ID : movedInID, MOVED_OUT_ID : movedOutID, LOCATION : location};
    NSString *updateURL = [NSString stringWithFormat:@"%@%@", BASE_URL, method];
    
    [WebClient requestPostUrl:updateURL parameters:dicParam suceess:^(NSArray *response) {
        finishBlock(response);
    } failure:^(NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
    
}

@end
