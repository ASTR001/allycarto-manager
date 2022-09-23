// Api related
import 'dart:ui';

import 'package:flutter/material.dart';

const apiBaseURL = "https://allycarto.com/api";
const apiImageBaseURL = "https://allycarto.com";

const MAP_API_KEY = "AIzaSyDdM7xizWi-vR1xUTQqiwhAnCHXLlhjje";
const MAP_API_ROUTE_KEY = "AIzaSyDzVye7vx-4UGgU2U-xlJHdtyuiHIfiAX";

const API_LOGIN = apiBaseURL + "/manager_login";
const API_UPDATE_PROFILE = apiBaseURL + "/distributer_update";
const API_ADD_VENDORS = apiBaseURL + "/add_vendors";
const API_EDIT_VENDORS = apiBaseURL + "/edit_vendors";
const API_GET_VENDORS = apiBaseURL + "/list_vendors/";
const API_PINCODE_LIST = apiBaseURL + "/pincode/";
const API_STAR_LIST = apiBaseURL + "/starrating";
const API_SHOP_TYPE = apiBaseURL + "/shoptype";
const API_VERTICAL_LIST = apiBaseURL + "/vertical_list";
const API_CATEGORY_LIST = apiBaseURL + "/maincategory_list";
const API_SUB_CATEGORY_LIST = apiBaseURL + "/sub_category_list";


////////////////  Vendor  ////////////////////////////

const API_BANNER = apiBaseURL + "/banner";
const API_ADD_PRODUCT = apiBaseURL + "/add_product";
const API_LIST_PRODUCT = apiBaseURL + "/list_product/";

const API_VENDOR_TICKET= apiBaseURL + "/ticket";
const API_VENDOR_CAT_BLOG= apiBaseURL + "/categoryblog/";
const API_VENDOR_COVERAGE= apiBaseURL + "/coveragelist";
const API_VENDOR_FAQ= apiBaseURL + "/faqlist";
const API_VENDOR_ACHIVER= apiBaseURL + "/achiverlist";
const API_VENDOR_ALBUM= apiBaseURL + "/albumlist";
const API_VENDOR_EVENT= apiBaseURL + "/eventgallery/";
const API_VENDOR_BLOG= apiBaseURL + "/bloglist";
const API_VENDOR_BLOG_CAT= apiBaseURL + "/blogcategory";
const API_VENDOR_PROMO= apiBaseURL + "/promo_video";
const API_VENDOR_SCHEME= apiBaseURL + "/schemelist";



const Color transparent = Color(0x00000000);
const Color layerOneBg = Color(0x80FFFFFF);
const Color layerTwoBg = Color(0xFFFFE9E9);

const Color forgotPasswordText = Color(0xFF024335);
const Color signInButton = Color(0xFF024335);

const Color checkbox = Color(0xFF024335);
const Color signInBox = Color(0xFF024335);

const Color hintText = Color(0xFFB4B4B4);
const Color inputBorder = Color(0xFF707070);