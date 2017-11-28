/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Team
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.handlers.notification;

import org.eclipse.core.commands.IHandler;
import org.eclipse.jface.dialogs.Dialog;

import biz.rapidfire.core.dialogs.maintenance.notification.NotificationMaintenanceDialog;
import biz.rapidfire.core.model.IRapidFireNotificationResource;
import biz.rapidfire.core.model.maintenance.IMaintenance;
import biz.rapidfire.core.model.maintenance.notification.NotificationValues;

public class CopyNotificationHandler extends AbstractNotificationMaintenanceHandler implements IHandler {

    public CopyNotificationHandler() {
        super(IMaintenance.MODE_COPY);
    }

    @Override
    protected void performAction(IRapidFireNotificationResource notification) throws Exception {

        NotificationValues values = getManager().getValues();

        NotificationMaintenanceDialog dialog = NotificationMaintenanceDialog.getCopyDialog(getShell(), getManager());
        dialog.setValue(values);

        if (dialog.open() == Dialog.OK) {
            getManager().book();
            refreshUI(notification);
        }
    }
}