CLASS zcl_system_info_rfc_000 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SYSTEM_INFO_RFC_000 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA msg TYPE c LENGTH 255.

    TRY.
        DATA(lo_destination) = cl_rfc_destination_provider=>create_by_comm_arrangement(

                                comm_scenario          = 'Z_OUTBOUND_RFC_000_CSCEN'   " Communication scenario
                                service_id             = 'Z_OUTBOUND_RFC_000_SRFC'    " Outbound service
                                comm_system_id         = 'Z_OUTBOUND_RFC_CSYS_000'    " Communication system

                             ).

        DATA(lv_destination) = lo_destination->get_destination_name( ).

        DATA: lv_result TYPE c LENGTH 500,
              lv_curr   TYPE sy-index,
              lv_max    TYPE sy-index.

        CALL FUNCTION 'RFC_SYSTEM_INFO'
          DESTINATION lv_destination
          IMPORTING
            rfcsi_export          = lv_result
            current_resources     = lv_curr
            maximal_resources     = lv_max
          EXCEPTIONS
            system_failure        = 1
            communication_failure = 2
            OTHERS                = 3.

        CASE sy-subrc.
          WHEN 0.
            out->write( lv_result ).
            out->write( lv_curr ).
            out->write( lv_max ).
          WHEN 1.
            out->write( | EXCEPTION SYSTEM_FAILURE | && msg ).
          WHEN 2.
            out->write( | EXCEPTION COMMUNICATION_FAILURE | && msg ).
          WHEN 3.
            out->write( | EXCEPTION OTHERS | ).
        ENDCASE.

      CATCH cx_root INTO DATA(lx_root).
        out->write( lx_root->get_text( ) ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
