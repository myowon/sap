*&---------------------------------------------------------------------*
*& Include          ZCMR7000TOP
*&---------------------------------------------------------------------*
CONSTANTS : gc_stru TYPE tabname VALUE 'zcms7000'.


*&---------------------------------------------------------------------*
*& Structure
*&---------------------------------------------------------------------*
DATA : BEGIN OF gs_error,
         head_key   TYPE i,
         key        TYPE i,
         field      TYPE fdname,
         field_text TYPE as4text,
         message    TYPE c LENGTH 100,
       END OF gs_error.

DATA : BEGIN OF gs_dup,
         head_key TYPE i,
         werks    TYPE mast-werks,
         matnr    TYPE mast-matnr,
         stlal    TYPE mast-stlal,
         dup      TYPE i,
       END OF gs_dup.
*&---------------------------------------------------------------------*
*& Internal Tables
*&---------------------------------------------------------------------*
TYPES : BEGIN OF ty_excel,
  NAME LIKE ZCMT7000-NAME,
  PHONE LIKE ZCMT7000-PHONE,
END OF ty_excel.

DATA : gt_list TYPE TABLE OF zcms7000,
       gt_excel TYPE TABLE OF ty_excel,
       gs_excel TYPE ty_excel,
       gt_error LIKE TABLE OF gs_error,
       gt_table TYPE TABLE OF zcmt7000,
       gs_table TYPE zcmt7000.
