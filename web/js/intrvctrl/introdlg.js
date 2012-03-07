


var IntroDlg = function () {
	
	var itemsOk = [];
//	var usrId; // the id of the current user
	var grpId; // the id of the current secondary active group
	
/**
 * This method makes a cross-component validation: all four form components
 * have to be correct
 */
	var checkConstraints = function () {
		var allValid = false;
		var allSame = false;
		for (var myItem in itemsOk) {
			var myVal = itemsOk[myItem];
			
			if (typeof(myVal) == "boolean") {
				allValid = (myVal == true) ? true : false;
				if (allValid == false) 
					break;
			}
		}
		
		if (allValid) {
			var txtCode = Ext.getCmp('patcode'), 
					txtCodeBis = Ext.getCmp('patcodebis');
			var codeType = Ext.getCmp('typeCombo'),
					codeTypeBis = Ext.getCmp('typeComboBis');
							
			allSame = (txtCode.getValue() == txtCodeBis.getValue());
			allSame = (codeType.getValue() == codeTypeBis.getValue()) && allSame;
		}
		
		if (objCfg.shrt == 1) {
			if (allSame) {
// console.info('Activating radion buttons!!!');
				Ext.getCmp('radioNormal').enable();
				Ext.getCmp('radioShort').enable();
				Ext.getCmp('btnOk').enable();
			}
			else {
				Ext.getCmp('radioNormal').disable();
				Ext.getCmp('radioShort').disable();
			}
		}
	}
	
	
	
	
/** 
 * This method is to check when a subject code component become valid
 * @param {Object} fieldComp
 */
	var subjectValid = function (fieldComp) {
// console.info (fieldComp.getName() + " is already valid");
		var theId = fieldComp.getId ();
		itemsOk [theId] = true;
		
		checkConstraints ();
	}
	
	
	
/** 
 * This method is to check when a subject code component become invalid
 * @param {Object} fieldComp
 */
	var subjectInvalid = function (fieldComp) {
// console.info (fieldComp.getName() + " is  invalid");
		var theId = fieldComp.getId ();
		itemsOk [theId] = false;
		
		checkConstraints ();
	}
	

/**
 * onChange the group combo a servlet has to be called to set the active 2grp!!
 * Both group code -to build the full patient code- and group id -to set the
 * active group for session- has to be considered
 * @param {Object} combo, the item which raised the event
 * @param {Object} record, the entry of the combo which was selected
 * @param {Object} index, the index of the element selected
 */
	var onChange = function (combo, record, index) {
		var msg = 'ComboId "'+combo.getId()+'" selected val: ';
		msg += record.data.id + '. '+record.data.name + ' (' + record.data.cod +')';
// console.info (msg);		
		
		if (combo.getId() == 'comboGrp') {
			Ext.Ajax.request ({
				url: APPNAME+'/servlet/MngGroupsServlet',
				method: 'POST',
				params: {intrvid: objCfg.intrvid, grpid:record.data.id},
				
				callback: function (options, success, resp) {
					var jsonResp = Ext.util.JSON.decode(resp.responseText);
					if (success == true) {
						// console.debug (jsonResp.msg);
// add secondary active group parameters to configuration object
						objCfg.grpid = record.data.id;
						objCfg.grpcode = record.data.cod;
						
// load the subject's combo with the subject for the objCfg.grpid
						comboSubj.enable();
					}
					
				},  // eo callback
				
				failure: function (resp, opts) {
					Ext.Msg.alert ("request failure: "+resp.responseText);
				}
			});
		}
		
// Enable the components for the panel holding type comboboxes
		Ext.getCmp ('typeCombo').enable();
		Ext.getCmp ('typeComboBis').enable();
		Ext.getCmp ('patcode').enable();
		Ext.getCmp ('patcodebis').enable ();
		
	}
	 	
	
// COMBOBOXES DEFINITION /////////////////////////////////////////////////
	var typeCombo = new Ext.form.ComboBox({
//		xtype: 'combo',
		fieldLabel: 'Type',
		allowBlank: false,
		store: typeJsonSt,
		displayField: 'name',
		valueField: 'id',
		typeAhead: true,
		mode: 'local',
		
		id: 'typeCombo',
		name: 'typeCombo',
		
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'Choose...',
		selectOnFocus: true,
		
		listeners: {
			select: onChange,
			valid: subjectValid,
			invalid: subjectInvalid
		}
	});
	
	
	var typeComboBis = new Ext.form.ComboBox({
//		xtype: 'combo',
		allowBlank: false,
		fieldLabel: 'Repeat Type',
		store: typeJsonSt,
		displayField: 'name',
		valueField: 'id',
		typeAhead: true,
		mode: 'local',
		id: 'typeComboBis',
		name: 'typeComboBis',
		
// cross validation against the other combo		
		forceSelection: true,
		vtype: 'subjType',
		anotherType: 'typeCombo',
		
		triggerAction: 'all',
		emptyText: 'Choose...',
		selectOnFocus: true,
		
		listeners: {
			select: onChange,
			valid: subjectValid,
			invalid: subjectInvalid
		}
	});	
	
	
	var grpCombo = new Ext.form.ComboBox({
//		xtype: 'combo',
		allowBlank: false,
		tpl: '<tpl for="."><div ext:qtip="{name:htmlEncode}" class="x-combo-list-item">{name:htmlDecode}</div></tpl>',
		fieldLabel: 'Groups',
		labelSeparator: '',
		labelStyle: "font-weight:bold; color:#15428b; margin-left: 10px;",
		store: grpJsonSt,
		displayField: 'name',
		valueField: 'cod',
		mode: 'local', // !!!!, with remote it would load data remotely on trigger
		
		id: 'comboGrp',
		name: 'comboGrp',
		
		emptyText: 'Select a hospital...',
		forceSelection: true,
		triggerAction: 'all',
		typeAhead: true,
		selectOnFocus: true,
		listWidth: 250,
		disabled: false,
		
		style: {
			marginLeft:'5px'
		},
		labelWidth: 110,
		
		listeners: {
			select: onChange
		}
	});
	
	
	var panelGrp = {
		xtype: 'panel',
		border: true,
		title: 'Groups',
		header: false,
		footer:false,
		
		style: {
			margin: "10px 0px 10px 0px",
//			borderColor: "#15428b",
			border: "1px solid darkgray"
		},
		
		items: [grpCombo]
	}
// COMBOBOXES DEFINITION ///////////////////////////////////////////////// 	


// SUBJECT CODES COMBO/PANEL DEFINITION //////////////////////////////////
// Very bad code practice: this is the same than above, obviously the data source
// is different...
	var comboSubj = new Ext.form.ComboBox ({
//		xtype: 'combo',
		allowBlank: true,
		tpl: '<tpl for="."><div ext:qtip="" class="x-combo-list-item">{code}</div></tpl>',
		fieldLabel: 'Subjects in group (-)',
		labelSeparator: '',
		labelStyle: "font-weight:bold; color:#15428b; margin-left: 10px;width:150;",
		store: subjJsonSt,
		displayField: 'code',
//		valueField: 'id',
		mode: 'local',
		
		loadingText: 'Searching...',
		
		id: 'comboSubj',
		name: 'comboSubj',
		
		emptyText: 'Subject codes ...',
		forceSelection: true,
		triggerAction: 'all',
		typeAhead: true,
		selectOnFocus: true,
		listWidth: 250,
		disabled: true,
		
		style: {
			marginLeft:'5px'
		},
		
		listeners: {
			enable: function (comp) {
				var compStore = comp.store;
				
				compStore.load({
					callback: function (records, opts, ok) {
						if (ok) {
							// changing label: this can be done as for extending a more general component
							var combo = Ext.getCmp('comboSubj');
							var formItem = combo.getEl().up ('.x-form-item');
							var label = formItem.down ('.x-form-item-label');
							
							label.dom.innerHTML = 'Subjects in group ('+compStore.getTotalCount()+')';
						}
					} // eo load event
				});
			}, // eo enable event
		} // eo listeners
		
	});
	
	
	var panelSubj = {
		xtype: 'panel',
		border: true,
		title: 'Subjects',
		header: false,
		footer:false,
		html: '<p style="text-align:center">This is <b>ONLY</b> intended for <b>reminder</b> or <b>querying</b> purposes</p>',
		
		style: {
			margin: "10px 0px 10px 0px",
			borderColor: "#15428b",
			border: "1px dotted lightgray"
		},
		
		items: [comboSubj]
	}
// EO SUBJECT CODES COMBO/PANEL DEFINITION ////////////////////////////////	
	
 	
// RADIOBTNS DEFINITION ///////////////////////////////////////////////////
	var radioShort = {
		xtype: 'radio',
		name: 'intrvType',
		id: 'radioShort',
		inputValue: '1',
		fieldLabel: "Short",
		boxLabel: "Short",
		columnWidth: 0.5
	}
	
	
	var radioNormal = {
		xtype: 'radio',
		checked: true,
		name: 'intrvType',
		id: 'radioNormal',
		inputValue: '2',
		fieldLabel: "Normal",
		boxLabel: "Normal",
		columnWidth: 0.5
	}
	
	
	var fsRadio = {
		xtype: 'fieldset',
		title: 'Choose interview type',
		layout: 'column',
		collapsible: false,
		autoHeight: true,
		border: true,
		
		style: {
//			background: "yellow"
			border: "1px solid darkgray"
		},
		defaults: {disabled: true},
		
		items: [radioShort, radioNormal]
	}
// RADIOBTNS DEFINITION ///////////////////////////////////////////////// 
	
	
// PANELS SUBJECT IDENTIFICATION ////////////////////////////////////////
// Panel for case/control subject combos
	var panelType = {
		xtype: 'panel',
		columnWidth: 0.5,
		border: false,
		header: false,
		footer: false,
		autoHeight: true,
		autoWidth: true,
		
		style: {
//			background: 'red',
			margin: "0px 5px 0px 0px"
		},
		
		defaults: {disabled: true},
		items: [typeCombo, typeComboBis]
	}
	
// Panel for code subject textfields
	var panelCode = {
		xtype: 'panel',
		columnWidth: 0.5,
		border: false,
		header: false,
		footer: false,
		autoHeight: true,
		autoWidth: true,
		defaultType: 'textfield',
		
		style: {
//			background: 'green',
			margin: "0px 0px 0px 5px"
		},
		
		items: [{
				fieldLabel: 'Subject code',
				allowBlank: false,
				id: 'patcode',
				name: 'patcode',
				
				vtype: 'subjCode',
//				anotherCode: 'patcodebis',
				maskRe: /\d/,
				maxLength: 3,
				
				disabled: true,
				width: 50,
				
				listeners: {
					valid: subjectValid,
					invalid: subjectInvalid
				}
			}, {
				fieldLabel: 'Repeat subject code',
				allowBlank: false,
				id: 'patcodebis',
				name: 'patcodebis',
				
				vtype: 'subjCode',
//				vtype: 'patcode',
				anotherCode: 'patcode',
				maskRe: /\d/,
				maxLength: 3,
				
				disabled: true,
				width: 50,
				
				listeners: {
					valid: subjectValid,
					invalid: subjectInvalid
				}
			}
		]
	}
	
// fieldset to set the column layout for subject fields identification	
	var fsSubject = {
		xtype:'fieldset',
		layout: 'column',
		collapsible: false,
		autoHeight: true,
		autoWidth: true,
		border: true,
		frame: true,
		title: 'Subject identification',
		
		defaults: {
			anchor: '-20',
			layout: 'form'
		},
		
		style: {
			border: "1px solid darkgray"
		},
		
		items: [panelType, panelCode]
	}
// PANELS SUBJECT IDENTIFICATION ////////////////////////////////////////
	
	var introForm = {
		xtype: 'form',
		header: false,
		id: 'introForm',
		name: 'introForm',
		monitorValid: true,
//		autoHeight: true,
		autoWidth: true,
//		labelAlign: 'right',
		buttonAlign: 'center',
//		layout: 'column',
		labelWidth: 120,
		
		defaults: {
			layout: 'form', 
			border: false, 
			frame: true,
			labelWidth: 110
		},
//		items: [grpCombo, fsSubject, fsRadio],
		items: [panelGrp, fsSubject, panelSubj], //, panelSubj],
		buttons: formBtns
	};
	
	
	var introWin;
	return {
		
		init: function () {
/* get the configuration	
			var paramCfg = new Array();
			paramCfg['what'] = 'perfcfg';
			objCfg = utils.config ('/appform/servlet/IntrvServlet', 
															paramCfg, 'GET', false);
*/
			
//
// Check for user permissions
			Ext.Ajax.request ({
				url: APPNAME+'/servlet/IntrvServlet',
				params: {
					what:'rolechk', 
				},
				method: 'GET',
				
				callback: function(options, success, resp) {
			// raise a msg in the case of success is false and interview is marked as short
		//			if (!success && shrt == 1) {
					if (!success) {
						var msg = "Failed to check user permissions. ";
						msg += 'Unable to continue, try again and contact the ';
						msg += ' <a href="mailto:'+utils.ADMIN_MAIL+'">administrator</a> if problem continues';
						
//						util.raiseMsg (msg);
//						return false;
					}
					
					var jsonOut = Ext.decode (resp.responseText);
					if (jsonOut.hasPermission != 1) {
						msg = "The user <b style=\"color:blue\">'"+jsonOut.username+"'</b> does <b style=\"color:red\">NOT</b>";
						msg += " have enough privileges to perform the interview.<br/>Allowed";
						msg += " <b style=\"color:red\">only</b> to see interview content<br/>";
						msg += "<br/><p align=\"center\" style=\"font-weight:bold\">Do you want to continue?</p>";
						
						utils.raiseYesNoDlg (msg, function (btnId) {
							if (btnId == 'no')
								window.self.close();	
						}) 
						
					}
					
					return false;
				}, // eo callback
				
				failure: function (resp, opts) {
					utils.raiseMsg ("Checking user permissions for interview performance failure: "+resp.responseText);
				}
			});
			
			
			
// init constraints for the user identification component
			itemsOk['patcode'] = false;
			itemsOk['patcodebis'] = false;
			itemsOk['typeCombo'] = false;
			itemsOk['typeComboBis'] = false;
			
			introWin = new Ext.Window ({
				id: 'mainWin',
				frame: true,
				closable: false,
				resizable: false,
//				height: 350,
				autoHeight: true,
				width: 540,
				title: 'Interview configuration',
				modal: true,
				draggable: false,
				
				defaults: {frame:true, autoHeight: true},
				items: [introForm]
			});
			
// this is to load the secondary active group if exists
			var myStore = grpCombo.store;
			myStore.addListener ('load', function (thisStore, records, options){
				
				if (objCfg.grpcode != undefined) {
	// console.info ('setting grpcode: '+objCfg.grpcode);
					grpCombo.setValue(objCfg.grpcode);
	
					Ext.getCmp ('typeCombo').enable();
					Ext.getCmp ('typeComboBis').enable();
					Ext.getCmp ('patcode').enable();
					Ext.getCmp ('patcodebis').enable ();
					Ext.getCmp ('comboSubj').enable ();
				}	
			});
			
			myStore.load ({params:{'what':'s', 'usrid': objCfg.usrid}});
			
			
//			myStore.load({params:{what:'s',usrid:usrid}});
			
			if (objCfg.shrt == 1) { // short interview allowed
				var theForm = Ext.getCmp ('introForm');
				theForm.add (fsRadio);
			}
		},
		
		
		display: function (domEl) {
			introWin.show ();
		}
		
	}
	
}();


Ext.onReady (function () {
// console.info("lets goooooo!!!!!");
	Ext.BLANK_IMAGE_URL = '../../js/lib/ext/resources/images/default/s.gif';
	
//	var anElem = Ext.get('container').applyStyles ("border: 2px dashed blue;margin: 50px");
	Ext.QuickTips.init();
	
//	IntroDlg.config();
	IntroDlg.init ();
	IntroDlg.display ();
});