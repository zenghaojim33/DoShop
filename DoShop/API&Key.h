//
//  API&Key.h
//  DoShop
//
//  Created by Anson on 15/2/4.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#ifndef DoShop_API_Key_h
#define DoShop_API_Key_h


#define UMAppKey @"54f3e183fd98c57ce30004fb"

#define BASE_URL @"http://www.dodovan.com"

#define LOGIN_API @"http://www.dodovan.com/json/client/index.ashx?aim=login"

#define RESET_PASSWORD_API @"http://www.dodovan.com/json/client/index.ashx?aim=forgetpwd"


#define CHANGE_INFO_API @"http://www.dodovan.com/json/upload.ashx?aim=update"

#define GET_PRODUCT_API @"http://www.dodovan.com/json/client/product.ashx?aim=productlist"

#define GET_INFO_API @"http://www.dodovan.com/json/client/index.ashx?aim=getinfor"


#define GET_BRAND_API @"http://www.dodovan.com/json/client/product.ashx?aim=getbrand&userid=%@"

#define SCAN_API @"http://www.dodovan.com/json/client/index.ashx?aim=bindsupplier"

#define CONFIRM_ON_SALE_API @"http://www.dodovan.com/json/client/product.ashx?aim=selectproduct"


#define GET_AUTH_CODE_CPi @"http://www.dodovan.com/json/sdkmsg.ashx"

#define REGISTER_API @"http://www.dodovan.com/json/client/index.ashx?aim=register"

#define CUSTOMER_MANAGEMENT_API @"http://www.dodovan.com/json/client/index.ashx?aim=customers&userid=%@&index=%ld&key=%@"

#define GET_ORDERINFO_API @"http://www.dodovan.com/json/client/index.ashx?aim=orderdetail&orderid=%ld"
#define GET_ORDER_API @"http://www.dodovan.com/json/client/index.ashx?aim=getorders&sellerid=%@&index=%ld&size=10&statu=%@&key=%@&starttime=%@&endtime=%@"

#define  GET_BACKLIST_API @"http://www.dodovan.com/json/client/index.ashx?aim=backlist&seller=%@&index=%ld&size=10&statu=%@&key=%@&starttime=%@&endtime=%@"
//退货明细
#define GET_BACKLISTINFO_API @"http://www.dodovan.com/json/client/index.ashx?aim=backdetail&backId=%ld"


#define GET_CUSTOMER_ORDER_API @"http://www.dodovan.com/json/client/index.ashx?aim=getorders&sellerid=%@&buyerid=%@&index=%ld&size=10&statu=-1"

#define GET_EVERYDAY_ORDER_NUM_API @"http://www.dodovan.com/json/client/index.ashx?aim=getordercount&sellerid=%@&size=10&index=%ld"

#define GET_EVERYDAY_SALES_NUM_API @"http://www.dodovan.com/json/client/index.ashx?aim=getorderallpric&sellerid=%@&size=10&index=%ld"

#define GET_EVERYDAY_VISITOR_NUM_API @"http://www.dodovan.com/json/client/index.ashx?aim=getvisitercount&sellerid=%@&size=10&index=%ld"


#define GET_INCOME_API @"http://www.dodovan.com/json/client/index.ashx?aim=myprofit&userid=%@&type=%ld&index=%ld"




#define GET_POSTAGE_API @"http://www.dodovan.com/json/client/order.ashx?aim=selectPostage&userid=%@"

#define UPDATE_POSTAGE_API @"http://www.dodovan.com/json/client/order.ashx?aim=updatePostage"

#define ADD_PROVINCE_API @"http://www.dodovan.com/json/client/order.ashx?aim=addProvinces"

#define UPDATE_PROVINCE_API @"http://www.dodovan.com/json/client/order.ashx?aim=updateProvinces"

#define DELETE_PROVINCE_API @"http://www.dodovan.com/json/client/order.ashx?aim=delProvinces"


//发货
#define SEND_ORDER_API @"http://www.dodovan.com/json/client/index.ashx?aim=ordersend"

//确认和拒绝退货
#define RETURN_CONFIRM_API @"http://www.dodovan.com/json/client/index.ashx?aim=applyback"
//确认退款
#define CONFIRM_REFUND_API @"http://www.dodovan.com/json/OrderRefund.ashx?aim=refund"


//商品详情页
#define PRODUCT_DETAIL_PAGE @"http://dudian.dodovan.com/DuShop/ProudtDetail.html?productID=%@&id=%@"


//消息
#define GET_MESSAGE_API @"http://www.dodovan.com/json/client/index.ashx?aim=messages"

//消息详情
#define GET_MESSAGEINFO_API @"http://www.dodovan.com/json/client/news.htm?id=%ld"
//快递100接口
#define KUAIDI100 @"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@"

//提现接口
#define WITHDRAW_API @"http://dodovan.com/json/Withdrawals.aspx"

#endif
