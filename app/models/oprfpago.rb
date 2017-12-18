# == Schema Information
#
# Table name: OPRFPAGO
#
# IEMP                            (T_IEMP) SMALLINT Not Null 
# INUMOPER                        (T_INUMOPER) INTEGER Not Null 
# ITIPOFPAGO                      (T_ITIPOFPAGO) SMALLINT Not Null 
# IDFPAGO                         SMALLINT Not Null 
# ID                              INTEGER Not Null 
# ICC                             (T_ICC) VARCHAR(20) Nullable 
# INIT                            (T_INIT) VARCHAR(20) Nullable 
# ICUENTA                         (T_ICUENTA) VARCHAR(30) Nullable 
# ITIPOTRANSACCION                (T_IBANCO) VARCHAR(4) Nullable 
# ITRANSACCION                    (T_ITRANSACCIONBANCARIA) VARCHAR(10) Nullable 
# FTRANSACCION                    (T_FECHA) DATE Nullable 
# IFLUJOEFEC                      (T_IFLUJOEFEC) VARCHAR(15) Nullable 
# ILINEAMOV                       (T_ILINEA) INTEGER Nullable 
# QDIASCXP                        SMALLINT Nullable 
# QDIASVENCIM                     SMALLINT Nullable 
# NCONCEPTO                       VARCHAR(100) Nullable 
# SLISTCUOTAS                     (T_MEMO) BLOB segment 80, subtype TEXT Nullable 
# BCONCEPTOCHANGED                (T_BOOLEAN) CHAR(1) Nullable DEFAULT 'F'
#                                 CHECK (VALUE IN ('T','F',null))
# ICXX                            (T_ICXX) VARCHAR(32) Nullable 
# MVALOR                          (T_MONETARIO) NUMERIC(18, 4) Nullable 
# MVROTRAMONEDA                   (T_MONETARIO) NUMERIC(18, 4) Nullable 
# BEDITVROTRAMONEDA               (T_BOOLEAN) CHAR(1) Nullable DEFAULT 'F'
#                                 CHECK (VALUE IN ('T','F',null))
# CONSTRAINT PK_OPRFPAGO:  Primary key (IEMP, INUMOPER, ITIPOFPAGO, IDFPAGO, ID)


# -*- encoding : utf-8 -*-
class Oprfpago < ActiveRecord::Base
    
  establish_connection :firebird
  
  attr_accessible :iemp, :inumoper, :itipofpago, :idfpago, :id, :icc, :init,
                  :icuenta, :itipotransaccion, :itransaccion, :ftransaccion,
                  :iflujoefec, :ilineamov, :qdiascxp, :qdiasvencim, :nconcepto,
                  :slistcuotas, :bconceptochanged, :icxx, :mvalor, :mvrotramoneda,
                  :beditvrotramoneda

  set_table_name "OPRFPAGO"

  # Constants
  ITIPOFPAGO = 3.freeze
  IDFPAGO = 5.freeze
  ID = 1.freeze  
    
end