CLASS zcl_product_via_rfc_000 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRODUCT_VIA_RFC_000 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


    DATA lt_product TYPE STANDARD TABLE OF  zce_product_000 .

    "In the trial version we cannot call RFC function module in backend systems
    DATA(lv_abap_trial) = abap_true.

    "Set RFC destination
    TRY.

        DATA(lo_destination) = cl_rfc_destination_provider=>create_by_comm_arrangement(
                              comm_scenario          = 'Z_OUTBOUND_RFC_000_CSCEN'      " Communication scenario
                              service_id             = 'Z_OUTBOUND_RFC_000'            " Outbound service
                              comm_system_id         = 'Z_OUTBOUND_RFC_CSYS_000'       " Communication system

                             ).


        "Check if data is requested
        IF io_request->is_data_requested(  ).

          DATA lv_maxrows TYPE int4.
          DATA(lv_skip) = io_request->get_paging( )->get_offset(  ).
          DATA(lv_top) = io_request->get_paging( )->get_page_size(  ).
          lv_maxrows = lv_skip + lv_top.

          IF lv_abap_trial = abap_true.
            lt_product = VALUE #(
                      ( productid = 'HT-1000' name = 'Notebook' )
                      ( productid = 'HT-1001' name = 'Notebook' )
                      ( productid = 'HT-1002' name = 'Notebook' )
                      ( productid = 'HT-1003' name = 'Notebook' )
                      ( productid = 'HT-1004' name = 'Notebook' )
                      ( productid = 'HT-1005' name = 'Notebook' )
                      ).

          ELSE.
            "Call BAPI
            CALL FUNCTION 'BAPI_EPM_PRODUCT_GET_LIST'
              DESTINATION lv_destination
              EXPORTING
                max_rows   = lv_maxrows
              TABLES
                headerdata = lt_product.

          ENDIF.
          "Set total no. of records
          io_response->set_total_number_of_records( lines( lt_product ) ).
          "Output data
          io_response->set_data( lt_product ).

        ENDIF.

      CATCH  cx_rfc_dest_provider_error INTO DATA(lx_dest).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
