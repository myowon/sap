*&---------------------------------------------------------------------*
*& Include          ZPPR0160S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_upload RADIOBUTTON GROUP r01 DEFAULT 'X' USER-COMMAND r01.
    SELECTION-SCREEN COMMENT 3(20)  TEXT-p01 FOR FIELD p_upload. "업로드
    PARAMETERS p_delete RADIOBUTTON GROUP r01.
    SELECTION-SCREEN COMMENT 26(20) TEXT-p02 FOR FIELD p_delete. "삭제
    PARAMETERS p_disp RADIOBUTTON GROUP r01.
    SELECTION-SCREEN COMMENT 49(20) TEXT-p03 FOR FIELD p_disp.   "조회
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b1.
*&---------------------------------------------------------------------*
*& 파일 선택
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  PARAMETERS p_file TYPE file_table-filename DEFAULT 'C:\' MODIF ID upl.
SELECTION-SCREEN END OF BLOCK b2.
