//
//  define.h
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#ifndef define_h
#define define_h


#endif /* define_h */
#define DEVICETYPE              @"deviceType"

#pragma mark - User Management

#define BASE_URL                @"http://ojoinventory.com/ojo/"
#define LOGIN_URL               @"mobile/users/login"
#define GET_ALL_USER_URL        @"mobile/users/getAllUser"
#define ADD_USER                @"mobile/users/addUser"
#define EDIT_USER_URL           @"mobile/users/editUser"
#define DELETE_USER_URL         @"mobile/users/deleteUser"
#define USERNAME                @"username"
#define NAME                    @"name"
#define NEW_NAME                @"new_name"
#define PASSWORD                @"psw_org"
#define EMAIL                   @"email"
#define ROLE                    @"role_id"
#define LOCATION                @"location_name"
#define PRENAME                 @"pre_name"
#define STATE                   @"state"
#define MESSAGE                 @"message"
#define SERVER_TIME             @"server_time"
#define GET_ALL_USER            @"all_users"
#define CHANGE_ADMIN_PASS       @"mobile/users/changePassword"
#define NEW_PASS                @"new_password"
#define OLD_PASS                @"current_password"


#define mark - Location Management

#define GET_ALL_LOCATION_URL    @"mobile/locations/getAllLocation"
#define ALL_LOCATION            @"location"

#define CONTROLLER              @"controller"
#define SEL_LOCATION            @"select_location"

#pragma mark - Category Management

#define GET_ALL_CATEGORY        @"mobile/categories/getAllCategory"
#define ADD_CATEGORY            @"mobile/categories/addCategory"
#define EDIT_CATEGORY           @"mobile/categories/editCategory"
#define DELETE_CATEGORY         @"mobile/categories/deleteCategory"
#define CATEGORY_NAME           @"name"
#define FULL_OPEN               @"full_open"
#define FREQUENCY               @"frequency"

#pragma mark - Item Management

#define GET_ALL_ITEM            @"mobile/items/getAllItem"
#define ADD_ITEM                @"mobile/items/addItem"
#define EDIT_ITEM               @"mobile/items/editItem"
#define DELETE_ITEM             @"mobile/items/deleteItem"
#define ITEM_NAME               @"item_name"
#define ITEM_CATEGORY           @"item_category"
#define BT_FULL_WET             @"bt_full_wet"
#define BT_EMP_WET              @"bt_emp_wet"
#define LIQ_WET                 @"liq_wet"
#define SERVE_BOTTLE            @"serv_bt"
#define SERVE_WET               @"serv_wet"
#define PRICE                   @"price"


#pragma mark - inventory management

#define INVENTORY_ITEM_NAME     @"item_name"
#define INVENTORY_FRUQUENCY     @"frequency"
#define INVENTORY_OPEN_BOTTLE_WET   @"open_bt_wet"
#define INVENTORY_NEW_OPEN_BOTTLE_WET @"news_open_bt_wet"
#define INVENTORY_PAR           @"par"
#define INVENTORY_AMOUNT        @"amount"
#define INVENTORY_NEW_AMOUNT    @"news_amount"
#define INVENTORY_FULL_OPEN     @"full_open"
#define INVENTORY_BT_FULL_WET   @"item_bt_full_wet"
#define INVENTORY_BT_EMP_WET    @"item_bt_emp_wet"
#define INVENTORY_LIQ_WET       @"item_liq_wet"
#define INVENTORY_SERV_BT       @"item_serv_bt"
#define INVENTORY_SERV_WET      @"item_serv_wet"
#define INVENTORY_ITEM_PRICE    @"item_price"
#define INVENTORY_CATEGORY      @"item_category"
#define INVENTORY_JSON          @"inventory_json"


#pragma mark - comment

#define COMMENT                 @"comment"
#define COMMENT_URL             @"mobile/comments/addComment"

#pragma mark - item move management

#define MOVE_ID                 @"move_id"
#define MOVED_IN_ID             @"moved_in_id"
#define MOVED_OUT_ID            @"moved_out_id"
#define MOVE_ITEM_NAME          @"item_name"
#define MOVE_ITEM_AMOUNT        @"amount"
#define SENDER_LOCATION         @"sender_location"
#define RECEIVER_LOCATION       @"receiver_location"
#define SENDER_NAME             @"name"
#define MOVED_TIME              @"moved_time_str"
#define MOVE_STATUS             @"read"
#define DATE_STR                @"date_str"
#define MOVE_ALLOW_URL          @"mobile/almacens/inventoryItemReceive"
#define MOVE_URL                @"mobile/moves/moveItem"
#define TODAY_MOVE_TIME_URL     @"mobile/almacens/searchMovedItemToday"


#pragma mark - item receive search

#define ITEM_MOVE_SEARCH        @"mobile/almacens/searchReceiveItem"
#define ITEM_MOVE_ALLOW         @"mobile/almacens/InventoryItemReceive"
#define ITEM_MOVE_REJECT        @"mobile/almacens/InventoryItemReject"
#define ITEM_MOVE_SEARCH_MANAGE @"mobile/almacens/searchManageReceiveItem"
#define SEARCH_UNREPORTED_ITEMS @"mobile/almacens/searchUnreportedItems"
#define UPDATE_UNREPORTED_MOVING    @"mobile/almacens/updateUnreportedItem"


