window.clientSideValidations.callbacks.element.fail = function(element, message, callback) {
	callback();
	if (element.data('valid') !== false) {
	    element.parent().find('.message');
	  }
	if (message == "La entidad ya se encuentra en el sistema") {
		element.next().after('<div id="status-vendor"><span class="toVendor">¿Desea agregarlo también como proveedor?</span><br /><div id="convertToVendor"><a href="#" id="entity-to-vendor" class="btn btn-primary convert-link">Sí</a><a href="#" id="cancel-convert" class="btn">No</a></div></div><div id="vendor-spinner"><img src="/assets/loader.gif" alt="Cargando" /></div>');
	}
}