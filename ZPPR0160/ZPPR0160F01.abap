*&---------------------------------------------------------------------*
*& Include          ZPPR0160F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
FORM modify_screen .

  LOOP AT SCREEN.
*   업로드/변경/조회 에 따라 선택화면 변경
    CASE 'X'.

      WHEN p_upload OR p_delete.
        IF screen-group1 = 'DIS'.
          screen-active = 0.
        ENDIF.

      WHEN p_disp.
        IF screen-group1 = 'UPL'.
          screen-active = 0.
        ENDIF.

    ENDCASE.

*   필수 필드
    CASE screen-name.
      WHEN 'S_WERKS-LOW' OR 'S_MATNR-LOW' OR 'P_FILE'.
        screen-required = 2.
    ENDCASE.

    MODIFY SCREEN.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form start_of_selection
*&---------------------------------------------------------------------*
FORM start_of_selection .

  CASE 'X'.
    WHEN p_upload  "업로드
      OR p_delete. "삭제

      PERFORM get_excel_data.    "Excel 데이터를 가져옴
      PERFORM get_text_of_field.
"      PERFORM set_display_data.  "Display 용 데이터

    WHEN p_disp.
      "PERFORM get_data.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form end_of_selection
*&---------------------------------------------------------------------*
FORM end_of_selection .

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_0100_output
*&---------------------------------------------------------------------*
FORM set_alv_0100_output .
  IF go_grid IS INITIAL.
    PERFORM create_alv_0100.
  ELSE.
    PERFORM refresh_alv_0100.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_excel_data
*&---------------------------------------------------------------------*
FORM get_excel_data .

  DATA lt_intern TYPE TABLE OF alsmex_tabline.

  DATA : ls_field      TYPE zcms7000.
  DATA : lt_field TYPE TABLE OF zcms7000.

  REFRESH gt_excel.

*--------------------------------
* Excel Data 를 SAP 내부 데이터로 변환
*--------------------------------

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = CONV rlgrap-filename( p_file )
      i_begin_col             = CONV i( 1 )
      i_begin_row             = CONV i( 2 )
      i_end_col               = CONV i( 20 )
      i_end_row               = CONV i( 500 )
    TABLES
      intern                  = lt_intern
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.


  FIELD-SYMBOLS <lfs_wa> TYPE any.

  DATA : ls_data     TYPE REF TO data,
         lr_strdescr TYPE REF TO cl_abap_structdescr,
         lt_dfies    TYPE ddfields,
         ls_dfies    TYPE dfies.

  CLEAR lt_dfies[].
  CREATE DATA ls_data LIKE LINE OF gt_excel.
  ASSIGN ls_data->* TO <lfs_wa>.

  lr_strdescr ?= cl_abap_structdescr=>describe_by_data( <lfs_wa> ).
  lt_dfies = cl_salv_data_descr=>read_structdescr( lr_strdescr ).

  CLEAR gt_excel[].

  LOOP AT lt_intern INTO DATA(ls_intern).

    ASSIGN COMPONENT ls_intern-col OF STRUCTURE <lfs_wa> TO FIELD-SYMBOL(<fs_value>).

*--- 값 지정
    IF <fs_value> IS ASSIGNED.
      <fs_value> = ls_intern-value.
    ENDIF.


*--- Data type 에 맞춰 내부 변환
    CASE ls_dfies-datatype.
      WHEN 'DATS'.
        REPLACE ALL OCCURRENCES OF '.' IN <fs_value> WITH ''.
        REPLACE ALL OCCURRENCES OF '/' IN <fs_value> WITH ''.
        REPLACE ALL OCCURRENCES OF '-' IN <fs_value> WITH ''.

      WHEN 'TIMS'.
        CONDENSE <fs_value> NO-GAPS.
        REPLACE ALL OCCURRENCES OF ':' IN <fs_value> WITH ''.

      WHEN 'NUMC'.
        <fs_value> = |{ <fs_value> ALPHA = IN }|.
    ENDCASE.

    AT END OF row.
      APPEND <lfs_wa> TO gt_excel.
      CLEAR <lfs_wa>.
    ENDAT.
  ENDLOOP.

  LOOP AT gt_excel INTO gs_excel.
    gs_table-mandt = sy-mandt.
    gs_table-name = gs_excel-name.
    gs_table-phone = gs_excel-phone.
    APPEND gs_table TO gt_table.
    CLEAR gs_table.
  ENDLOOP.

  INSERT ZCMT7000 FROM TABLE gt_table ACCEPTING DUPLICATE KEYS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_text_of_field
*&---------------------------------------------------------------------*
FORM get_text_of_field .

  gt_field = zcl_pp_common=>build_fieldcat_from_structure( gc_stru ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_display_data
*&---------------------------------------------------------------------*
FORM set_display_data .

  DATA : lt_list LIKE gt_list,
         ls_list LIKE LINE OF gt_list.



ENDFORM.
