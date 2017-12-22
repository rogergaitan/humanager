# == Schema Information
#
# Table name: OPRMOV1_DETALLE
#
# PF IEMP         :smallint (T_IEMP) not null
# PF INUMOPER     :integer (T_INUMOPER) not null
# PF ILINEA       :integer (T_INUMOPER) not null
# ICC             :varchar(20) (T_ICC)
# ICUENTA         :varchar(30) (T_ICUENTA)
# TDETALLE        :varchar(200) (T_SOBSERVOPRS)
# MVRBASE         :numeric(18,4) (T_MONETARIO)
# IBANCO          :varchar(4) (T_IBANCO)
# ICHEQUE         :varchar(10) (T_ITRANSACCIONBANCARIA)
# INIT            :varchar(20) (T_INIT)
# FSOPORT         :date (T_FECHA)
# INITCXX         :varchar(20) (T_INIT)
# FPAGOCXX        :date (T_FECHA)
# FVENCIMCXX      :date (T_FECHA)
# MDEBITO         :numeric(18,4) (T_MONETARIO)
# MCREDITO        :numeric(18,4) (T_MONETARIO)
# IACTIVO         :varchar(10) (T_IACTIVO)
# INUMSOPCXX      :varchar(32) (T_ICXX)
# IFLUJOEFEC      :varchar(5) (T_IFLUJOEFEC)
# MVROTRAMONEDA   :numeric(18,4) (T_MONETARIO)
# SCOMANDOS       :varchar(40)
# ILINEAMOV       :integer (T_ILINEA)
# VALOR1          :numeric(12,8) (T_CANT_FLOTANTES)
# VALOR2          :numeric(12,8) (T_CANT_FLOTANTES)
# CLASE1          :varchar(10) (T_CLASEMOVCNT)
# CLASE2          :varchar(10) (T_CLASEMOVCNT)
# -*- encoding : utf-8 -*-

class Oprmov1Detalle < ActiveRecord::Base

	establish_connection :firebird

	attr_accessible :iemp, :inumoper, :ilinea, :icc, :icuenta, :tdetalle, :mvrbase, 
					        :ibanco, :icheque, :init, :fsoport, :initcxx, :fpagocxx, :fvencimcxx,
					        :mdebito, :mcredito, :iactivo, :inumsopcxx, :iflujoefec, :mvrotramoneda,
					        :scomandos, :ilineamov, :valor1, :valor2, :clase1, :clase2

	set_table_name "OPRMOV1_DETALLE"

end