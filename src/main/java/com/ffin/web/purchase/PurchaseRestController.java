package com.ffin.web.purchase;

import com.ffin.service.domain.*;
import com.ffin.service.purchase.PurchaseService;
import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.request.CancelData;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.lang.Integer.parseInt;

@RestController
@RequestMapping("/purchase/*")
public class PurchaseRestController {

    @Autowired
    @Qualifier("purchaseServiceImpl")
    private PurchaseService purchaseService;

    public PurchaseRestController(){
        System.out.println(this.getClass());
    }

    @RequestMapping( value = "json/addPayView", method=RequestMethod.POST)
    @ResponseBody
    public ModelAndView addPayView(HttpServletRequest request ,@RequestParam(value = "payOption") int payOption,
                                   @RequestParam(value = "orderTotalPrice") int orderTotalPrice,@RequestParam(value = "orderUserId") String orderUserId,
                                   @RequestParam(value = "orderTruckId") String orderTruckId,@RequestParam(value = "orderNo") int orderNo,
                                   @RequestParam(value = "pointAmt") int pointAmt,@RequestParam(value = "couponNo") int couponNo,
                                   @RequestParam(value = "imp_uid") String imp_uid,@RequestParam(value = "payPrice")int payPrice,
                                   HttpServletResponse response  )throws Exception{

        request.setCharacterEncoding("UTF-8");
        System.out.println("request = " + request + ", payOption = " + payOption + ", orderTotalPrice = " + orderTotalPrice + ", orderUserId = " + orderUserId + ", orderTruckId = " + orderTruckId + ", orderNo = " + orderNo + ", pointAmt = " + pointAmt + ", couponNo = " + couponNo + ", imp_uid = " + imp_uid + ", response = " + response);
        System.out.println("\n\n json/addPayView POST \n\n\n");
        Purchase purchase = new Purchase();
        ModelAndView modelAndView = new ModelAndView();
        OrderDetail orderDetail = new OrderDetail();
        Coupon coupon = new Coupon();
        Point point = new Point();
        User user = new User();
        Truck truck = new Truck();

        user.setUserId(orderUserId);
        truck.setTruckId(orderTruckId);
        int appendPoint = (payPrice*2/100);
        //추후 payPrice를 가져오게 되면 orderTotalPrice랑 교체





        user = purchaseService.getTotalPoint(user.getUserId());
        user.setUserTotalPoint(user.getUserTotalPoint()+appendPoint);
        purchase.setOrderNo(orderNo);
        purchase.setPayPrice(payPrice);
        purchase.setPayOption(payOption);
        purchase.setOrderTotalPrice(orderTotalPrice);
        purchase.setOrderUserId(user);
        purchase.setOrderTruckId(truck);
        purchase.setPayServiceType(1);
        purchase.setOrderStatus(1);
        purchase.setPayId(imp_uid);


        purchaseService.updateTotalPoint(user);
        point.setPointUserId(user);
        point.setPointAmt(appendPoint);
        point.setPointPlmnStatus(1);
        point.setPointStatus(0);
        point.setPointBirthCode(orderNo);
        purchaseService.updatePoint(point);


        if(couponNo != 0) {
            coupon.setCouponReceivedUserId(user);
            coupon.setCouponStatus(1);
            coupon.setCouponNo(couponNo);
            purchaseService.updateCouponStatus(coupon);
            purchase.setPayCouponNo(coupon);
        }

        if(pointAmt != 0) {
            user = purchaseService.getTotalPoint(user.getUserId());
            user.setUserTotalPoint(user.getUserTotalPoint()-pointAmt);
            point.setPointAmt(pointAmt);
            point.setPointPlmnStatus(0);
            point.setPointBirthCode(orderNo);
            int pointNo = purchaseService.updatePoint(point);
            purchaseService.updateTotalPoint(user);
            point.setPointNo(pointNo);
            purchase.setPayPointNo(point);
        }
        System.out.println("\n\n\n ///////////////////////////////////////\n"+purchase);
        purchaseService.updatePurchase(purchase);
        //int orderNo = purchaseService.addPurchase(purchase);
        // orderDetail.setOdOrderNo(purchase);
        //Map cart = purchaseService.getCartList(orderNo);
        //purchase = purchaseService.getPurchase(orderNo);
        //User totalPoint = purchaseService.getTotalPoint(purchase.getOrderUserId().getUserId());
        return modelAndView;
    }
    @RequestMapping( value = "json/addCartList", method = RequestMethod.POST)
    @ResponseBody
    public Object addCartList(@RequestParam(value="odMenuName[]") List<String> odMenuName,
                            @RequestParam(value="odOptionGroupName[]") List<String> odOptionGroupName,
                            @RequestParam(value="odOptionName[]") List<String> odOptionName,
                            @RequestParam(value="odMenuQty[]") List<String> odMenuQty,
                            @RequestParam(value="odMenuPrice[]") List<String> odMenuPrice,
                            @RequestParam(value="odOptionPrice[]") List<String> odOptionPrice,
                            @RequestParam(value="odMenuImage[]") List<String> odMenuImage,
                            @RequestParam(value="orderPickUpTime") int orderPickUpTime,
                            @RequestParam(value="orderTotalPrice") int orderTotalPrice,
                            @RequestParam(value="orderUserId") String orderUserId,
                            @RequestParam(value="orderTruckId") String orderTruckId,
                            @RequestParam(value="orderRequest") String orderRequest,
                            @RequestParam(value="orderQty") int orderQty,
                            @RequestParam(value="odMenuQtyFlag[]")List<String> odMenuQtyFlag

                                                                      )throws IOException,Exception{
        System.out.println("json/addCartList POST");
        System.out.println("odMenuName = " + odMenuName + ", odOptionGroupName = " + odOptionGroupName + ", odOptionName = " + odOptionName + ", odMenuQty = " + odMenuQty + ", odMenuPrice = " + odMenuPrice + ", odOptionPrice = " + odOptionPrice + ", odMenuImage = " + odMenuImage + ", orderPickUpTime = " + orderPickUpTime + ", orderTotalPrice = " + orderTotalPrice + ", orderUserId = " + orderUserId + ", orderTruckId = " + orderTruckId + ", orderRequest = " + orderRequest + ", orderQty = " + orderQty + ", odMenuQtyFlag = " + odMenuQtyFlag);
        Purchase purchase = new Purchase();
        OrderDetail orderDetail = new OrderDetail();
        User user = new User();
        Truck truck = new Truck();

        user.setUserId(orderUserId);
        truck.setTruckId(orderTruckId);

        purchase.setOrderPickUpTime(orderPickUpTime);
        purchase.setOrderTotalPrice(orderTotalPrice);
        purchase.setOrderUserId(user);
        purchase.setOrderTruckId(truck);
        purchase.setOrderRequest(orderRequest);
        purchase.setOrderQty(orderQty);


        System.out.println("odMenuName length"+odMenuName.size());
        System.out.println("odOptionGroupName length"+odOptionGroupName.size());
        System.out.println("odOptionName length"+odOptionName.size());
        System.out.println("odMenuQty length"+odMenuQty.size());
        System.out.println("odMenuPrice length"+odMenuPrice.size());
        System.out.println("odOptionPrice length"+odOptionPrice.size());
        System.out.println("odMenuImage length"+odMenuImage.size());
        System.out.println("odMenuQtyFlag length"+odMenuQtyFlag.size());

        int orderNo = purchaseService.addPurchase(purchase);
        orderDetail.setOdOrderNo(purchase);
        Purchase pur = new Purchase();


        List <OrderDetail> orderList = new ArrayList<OrderDetail>();

        for (int i = 0; i< odMenuName.size(); i++){
            OrderDetail order = new OrderDetail();

            order.setOdMenuName(odMenuName.get(i));
            if(i>=odOptionGroupName.size()){
                order.setOdOptionGroupName(null);
            }else{
                order.setOdOptionGroupName(odOptionGroupName.get(i));
            }
            if(i>=odOptionName.size()){
                order.setOdOptionName(null);
            }else{
                order.setOdOptionName(odOptionName.get(i));
            }
            if(i>=odOptionName.size()){
                order.setOdOptionName(null);
            }else{
                order.setOdOptionName(odOptionName.get(i));
            }
            if(i>=odMenuQty.size()){
                order.setOdMenuQty(0);
            }else{
                order.setOdMenuQty(parseInt(odMenuQty.get(i)));
            }
            if(i>=odMenuPrice.size()){
                order.setOdMenuPrice(0);
            }else{
                order.setOdMenuPrice(parseInt(odMenuPrice.get(i)));
            }
            if(i>=odOptionPrice.size()){
                order.setOdOptionPrice(0);
            }else{
                order.setOdOptionPrice(parseInt(odOptionPrice.get(i)));
            }
            if(i>=odMenuImage.size()){
                order.setOdMenuImage(null);
            }else{
                order.setOdMenuImage(odMenuImage.get(i));
            }
            if(i>=odMenuQtyFlag.size()){
                order.setOdMenuQtyFlag(0);
            }else{
                order.setOdMenuQtyFlag(parseInt(odMenuQtyFlag.get(i)));
            }

            pur.setOrderNo(orderNo);
            order.setOdOrderNo(pur);


            orderList.add(order);
        }

        purchaseService.addCart(orderList);
        System.out.println(orderNo);

        Map<String,Object> retVal = new HashMap<String,Object>();
        retVal.put("code","OK");
        retVal.put("orderNo",orderNo);


        return retVal;

    }


///////////////////////////////////환불////////////////////////////////////////

    IamportClient client;

    public void setup() throws Exception {
        String api_key = "4137265660436852";
        String api_secret = "cddee6e3a9dcb5f0fd4c8d7fa6c8949fc346c818f164e6bad7a7d94848da04a36756a3f60a031a5d";

        client = new IamportClient(api_key, api_secret);
    }

    public void testGetToken() throws Exception {
        String token = String.valueOf(client.getAuth());
        System.out.println("token : " + token);
    }

    @RequestMapping(value = "/json/payRefund",  method = RequestMethod.POST)
    @ResponseBody
    public Map payRefund(@RequestParam(value = "payId")String payId,
                         @RequestParam(value = "orderNo")int orderNo,
                         @RequestParam(value = "orderCancelReason")int orderCancelReason,
                         HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 이미 취소된 거래 imp_uid
        System.out.println("testCancelPaymentByImpUid --- Start!---");
        System.out.println("payId = " + payId + ", orderNo = " + orderNo + ", orderCancelReason = " + orderCancelReason);

        Purchase purchase = new Purchase();
        purchase.setPayId(payId);
        purchase.setOrderStatus(5);
        purchase.setOrderNo(orderNo);
        if(orderCancelReason != 0 ) {
            purchase.setOrderCancelReason(orderCancelReason);
        }else{
            int orderNopeReason = Integer.parseInt(request.getParameter("orderNopeReason"));
            purchase.setOrderNopeReason(orderNopeReason);
        }



       /* Map<String, Object> map =  orderService.getOrderRefund(order);*/
        Map<String, Object> map =  new HashMap<String,Object>();

        setup();
        testGetToken();
        setup();
        //Order order = orderService.getFlightOrder(orderId);

        CancelData cancel = new CancelData(payId, true);
        System.out.println("imp_uid : " + payId);
        IamportResponse<Payment> cancelpayment = client.cancelPaymentByImpUid(cancel);
        System.out.println(cancelpayment.getMessage());
        System.out.println("testCancelPaymentByImpUid --- End!---");

        purchase.setPayRefundStatus(1);

        if(orderCancelReason != 0 ) {
            purchaseService.updateOrderCancel(purchase);
        }else{

            purchaseService.updateOrderRefusal(purchase);
        }
        purchase = purchaseService.getPurchase(orderNo);
        User user = purchaseService.getTotalPoint(purchase.getOrderUserId().getUserId());

        int appendPoint = (purchase.getPayPrice()*2/100);
        System.out.println("appendPoint///////////////"+appendPoint);
        Point point = new Point();
        point.setPointUserId(user);
        point.setPointAmt(appendPoint);
        point.setPointPlmnStatus(3);
        point.setPointStatus(0);
        point.setPointBirthCode(orderNo);
        user.setUserTotalPoint(user.getUserTotalPoint()-appendPoint);
        purchaseService.updatePoint(point);
        purchaseService.updateTotalPoint(user);


        purchase.getOrderUserId();

        //결제시 포인트 사용내역이 있으면
        if(purchase.getPayPointNo().getPointNo() != 0 || purchase.getPayPointNo().getPointNo() != ' ') {
            user = purchaseService.getTotalPoint(purchase.getOrderUserId().getUserId());
            int usePoint = purchaseService.getUsePoint(purchase.getPayPointNo().getPointNo());
            point.setPointAmt(usePoint);
            point.setPointPlmnStatus(2);
            user.setUserTotalPoint(user.getUserTotalPoint()+usePoint);
            purchaseService.updatePoint(point);
            purchaseService.updateTotalPoint(user);
        }
        //결제시 쿠폰 사용내역이 있으면
        if(purchase.getPayCouponNo().getCouponNo() !=0 || purchase.getPayCouponNo().getCouponNo() !=' '){
            Coupon coupon = new Coupon();
            coupon.setCouponStatus(0);
            coupon.setCouponNo(purchase.getPayCouponNo().getCouponNo());
            purchaseService.updateCouponStatus(coupon);
        }


        //환불 일시를 controller에서 할지 Mapper에서 할지 수정,,
/*        SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");

        String time1 = format1.format(System.currentTimeMillis());
        order.setRefundDate(time1);*/
/*        System.out.println("time : "+time1);
        System.out.println("order : "+order);
        map.put("orderId", orderId);
        map.put("order", order);*/

        return map;
    }

    ///////////////////////////////환불 끝///////////////////////////////////////////////

    //addIamport
    //cancelIamport
    //getCouponList




    //트럭 주문목록에서 접수 버튼클릭!!
    @RequestMapping( value = "json/updateTranCode", method = RequestMethod.POST)
    @ResponseBody
    public ModelAndView updateTranCode(@RequestParam("orderNo") int orderNo,@RequestParam("orderCookingTime") int orderCookingTime,HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");
        System.out.println("json/updateTranCode POST");
        System.out.println("orderNo = " + orderNo + ", request = " + request + ", response = " + response);
       // int orderNo = Integer.parseInt(request.getParameter("orderNo"));
        ModelAndView mv = new ModelAndView("jsonView");
        Purchase purchase = purchaseService.getPurchase(orderNo);
        purchase.setOrderCookingTime(orderCookingTime);
        if (purchase.getOrderStatus()==1) {
            purchase.setOrderStatus(2);
        }else if(purchase.getOrderStatus()==2){
            purchase.setOrderStatus(3);
        }else if(purchase.getOrderStatus()==3){
            purchase.setOrderStatus(4);
        }

        purchaseService.updateOrderTranCode(purchase);
        mv.addObject("purchase",purchase);

        return mv;
    }


    //트럭 주문목록에서 이용자 아이디 클릭으로 상세보기
    @RequestMapping( value = "json/getPurchase", method = RequestMethod.POST)
    @ResponseBody
    public ModelAndView getPurchase(@RequestParam("orderNo") int orderNo,HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");
        System.out.println("json/getPurchase POST");
        System.out.println("orderNo = " + orderNo + ", request = " + request + ", response = " + response);

        Map map = purchaseService.getOrderDetail(orderNo);
        ModelAndView mv = new ModelAndView("jsonView");
        Purchase purchase = purchaseService.getPurchase(orderNo);
        mv.addObject("purchase",purchase);
        mv.addObject("map",map.get("list"));

        return mv;
    }

    //영업중 모드 변경
    @RequestMapping( value = "json/updateBusiStatus", method = RequestMethod.POST)
    @ResponseBody
    public ModelAndView updateBusiStatus(@RequestParam("tb") String tb,HttpServletRequest request,
                                         HttpServletResponse response,@RequestParam("truckId")String truckId)throws Exception{
        request.setCharacterEncoding("UTF-8");
        System.out.println("json/updateBusiStatus POST");
        System.out.println("tb = " + tb + ", request = " + request + ", response = " + response + ", truckId = " + truckId);
        Truck truck = new Truck();


        truck.setTruckId(truckId);
        if(tb.equals("0")){
            truck.setTruckBusiStatus("1");
        }else if(tb.equals("1")){
            truck.setTruckBusiStatus("0");
        }
        purchaseService.updateBusiStatus(truck);


        ModelAndView mv = new ModelAndView("jsonView");
        return mv;
    }


}
