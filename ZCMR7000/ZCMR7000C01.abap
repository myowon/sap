*&---------------------------------------------------------------------*
*& Include          ZCMR7000C01
*&---------------------------------------------------------------------*

*>> LOCAL CLASS CL_EVENT_RECEIVER DEFINITION
CLASS cl_event_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS:
      handle_data_changed
        FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING sender e_row e_column,

      handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING sender e_row_id e_column_id,

      handle_tool_bar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      handle_on_f4 FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING sender e_fieldname e_fieldvalue es_row_no
                  er_event_data et_bad_cells e_display,

      handle_button_click
        FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no.

ENDCLASS.                        "CL_EVENT_RECEIVER DEFINITION)


*>> LOCAL CLASS CL_EVENT_RECEIVER Implementation
CLASS cl_event_receiver IMPLEMENTATION.

  METHOD handle_data_changed.
*    PERFORM modify_data USING er_data_changed.
  ENDMETHOD.                    "HANDLE_DATA_CHANGED

  METHOD handle_double_click.
*    PERFORM double_click USING e_row e_column.
  ENDMETHOD.                    "HANDLE_DOUBLE_CLICK1

  METHOD handle_hotspot_click.
*    PERFORM hotspot_click USING sender e_row_id e_column_id.
  ENDMETHOD.                    "HANDLE_HOTSPOT_CLICK

  METHOD handle_tool_bar.
*    PERFORM handle_tool_bar USING e_object e_interactive.
  ENDMETHOD.                    "HANDLE_TOOL_BAR

  METHOD handle_user_command.
*    PERFORM handle_user_command USING e_ucomm.
  ENDMETHOD.                    "HANDLE_USER_COMMAND

  METHOD handle_on_f4.
*    PERFORM HANDLE_ON_F4 USING E_FIELDNAME
*                              ES_ROW_NO
*                              ER_EVENT_DATA SENDER.
  ENDMETHOD.                                                "ON_F4
  METHOD handle_button_click.
*    PERFORM HANDLE_BUTTON_CLICK USING ES_COL_ID
*                                      ES_ROW_NO.
  ENDMETHOD.                    "HANDLE_BUTTON_CLICK

ENDCLASS.                    "CL_EVENT_RECEIVER IMPLEMENTATION

DATA go_event_receiver     TYPE REF TO cl_event_receiver.

*>>  GLOBAL ALV DEFINITION
DATA: go_grid TYPE REF TO cl_gui_alv_grid.

DATA: go_docking_con TYPE REF TO cl_gui_docking_container.

DATA : go_splitter    TYPE REF TO cl_gui_splitter_container,
       go_top_of_page TYPE REF TO cl_gui_container,
       go_container  TYPE REF TO cl_gui_container.

DATA: gs_field  TYPE lvc_s_fcat,
      gt_field TYPE lvc_t_fcat,
      gt_fieldcat TYPE lvc_t_fcat,
      gs_sort      TYPE lvc_s_sort,
      gt_sort      TYPE lvc_t_sort,
      gs_f4        TYPE lvc_s_f4,
      gt_f4        TYPE lvc_t_f4,
      gs_rows      TYPE lvc_s_row,
      gt_rows      TYPE lvc_t_row,
      gt_exclude   TYPE ui_functions,
      gs_layout   TYPE lvc_s_layo,
      gs_variant  TYPE disvariant.

DATA gv_okcode TYPE sy-ucomm.

*&---------------------------------------------------------------------*
*& Form create_alv_0100
*&---------------------------------------------------------------------*
FORM create_alv_0100 .

  PERFORM create_docking.
  PERFORM set_layout.
  PERFORM set_fieldcat.
  PERFORM set_toolbar.
  PERFORM set_event.
  PERFORM set_variant.
  PERFORM set_table_display.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_docking
*&---------------------------------------------------------------------*
FORM create_docking .

* Create docking container
  go_docking_con = NEW #( repid     = sy-repid
                          dynnr     = sy-dynnr
                          extension = 3000 ).

* Split docking container
  go_splitter = NEW #( parent  = go_docking_con
                       rows    = 1
                       columns = 1 ).

* Set split height
  go_splitter->set_row_height( EXPORTING id = 1 height = 100 ).

* Sets Configuration for Line Splitter Bar
*  go_splitter->set_row_sash( EXPORTING id = 1 type = 0 value = 1 ).
*  go_splitter->set_row_sash( EXPORTING id = 2 type = 1 value = 1 ).
*  go_splitter->set_row_sash( EXPORTING id = 3 type = 1 value = 1 ).

* Set Container in splitter
  go_container  = go_splitter->get_container( EXPORTING row = 1 column = 1 ).

* Create grid objects
  go_grid = NEW #( i_parent = go_container ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
FORM set_layout .

  gs_layout-zebra      = abap_on.       " 교대 색상 처리
  gs_layout-cwidth_opt = abap_on.       " 열 최적화

* Select mode
  CASE abap_on.
    WHEN p_upload.
      gs_layout-sel_mode   = 'B'.       " 단일 선택
    WHEN p_disp.
      gs_layout-sel_mode   = 'D'.       " 멀티 선택
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fieldcat
*&---------------------------------------------------------------------*
FORM set_fieldcat .

  DATA lv_fname TYPE lvc_s_fcat-reptext.

  "필드 카탈로그 추출
  CASE abap_on.
    WHEN p_upload.
      gt_fieldcat[] = zcl_pp_common=>build_fieldcat_from_structure( gc_stru1 ).
    WHEN p_disp.
      gt_fieldcat[] = zcl_pp_common=>build_fieldcat_from_structure( gc_stru2 ).
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_alv_0100
*&---------------------------------------------------------------------*
FORM refresh_alv_0100 .

  PERFORM refresh_grid USING go_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
FORM refresh_grid  USING p_grid TYPE REF TO cl_gui_alv_grid.

  DATA ls_stable TYPE lvc_s_stbl.

  ls_stable-col = 'X'.
  ls_stable-row = 'X'.

  CALL METHOD p_grid->refresh_table_display
    EXPORTING
      is_stable = ls_stable.

  CALL METHOD cl_gui_cfw=>flush.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_event
*&---------------------------------------------------------------------*
FORM set_event .

  CREATE OBJECT go_event_receiver.

*  SET HANDLER g_event_receiver->handle_data_changed  FOR g_grid.
*  SET HANDLER g_event_receiver->handle_on_f4         FOR g_grid.
*  SET HANDLER g_event_receiver->handle_hotspot_click FOR g_grid.
*  SET HANDLER g_event_receiver->handle_tool_bar      FOR g_grid.
*  SET HANDLER g_event_receiver->handle_user_command  FOR g_grid.
*  SET HANDLER go_event_receiver->handle_double_click  FOR go_grid1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
FORM set_variant .

  gs_variant-report   = sy-repid.
  gs_variant-username = sy-uname.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_table_display
*&---------------------------------------------------------------------*
FORM set_table_display .

  FIELD-SYMBOLS <ft_data> TYPE ANY TABLE.

  CASE abap_on.
    WHEN p_upload.
      ASSIGN gt_excel TO <ft_data>.

    WHEN p_disp.
      ASSIGN gt_disp TO <ft_data>.
  ENDCASE.

  CALL METHOD go_grid->set_table_for_first_display
    EXPORTING
      i_save               = 'A'
      it_toolbar_excluding = gt_exclude
      is_layout            = gs_layout
      is_variant           = gs_variant
    CHANGING
      it_fieldcatalog      = gt_fieldcat[]
      it_outtab            = <ft_data>
      it_sort              = gt_sort[].

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_toolbar
*&---------------------------------------------------------------------*
FORM set_toolbar .

  APPEND cl_gui_alv_grid=>mc_fc_loc_copy          TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row      TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut           TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_views             TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_info              TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_graph             TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_refresh           TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_undo          TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row    TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row    TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste         TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row    TO gt_exclude.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fieldcat_text
*&---------------------------------------------------------------------*
FORM set_fieldcat_text  USING pv_field_text
                       CHANGING cs_fieldcat TYPE lvc_s_fcat.

  cs_fieldcat-reptext   = pv_field_text.
  cs_fieldcat-coltext   = pv_field_text.
  cs_fieldcat-scrtext_s = pv_field_text.
  cs_fieldcat-scrtext_m = pv_field_text.
  cs_fieldcat-scrtext_l = pv_field_text.

ENDFORM.
