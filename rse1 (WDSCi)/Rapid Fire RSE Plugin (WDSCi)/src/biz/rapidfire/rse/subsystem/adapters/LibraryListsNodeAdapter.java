/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Team
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.rse.subsystem.adapters;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.widgets.Shell;

import biz.rapidfire.core.RapidFireCorePlugin;
import biz.rapidfire.core.dialogs.MessageDialogAsync;
import biz.rapidfire.core.model.IRapidFireJobResource;
import biz.rapidfire.rse.Messages;
import biz.rapidfire.rse.RapidFireRSEPlugin;
import biz.rapidfire.rse.subsystem.resources.LibraryListsNode;

import com.ibm.etools.systems.core.ui.SystemMenuManager;

public class LibraryListsNodeAdapter extends AbstractNodeAdapter {

    @Override
    public final boolean hasChildren(Object element) {
        return true;
    }

    @Override
    public String getText(Object element) {
        return Messages.NodeText_LibraryLists;
    }

    @Override
    public String getAbsoluteName(Object element) {
        return "node.library.lists"; //$NON-NLS-1$
    }

    @Override
    public void addActions(SystemMenuManager menuManager, IStructuredSelection selection, Shell shell, String paramString) {
        // menuManager.add(null, new NewLibraryListsNodePopupMenuAction(shell));
    }

    @Override
    public ImageDescriptor getImageDescriptor(Object element) {
        return RapidFireRSEPlugin.getDefault().getImageRegistry().getDescriptor(RapidFireRSEPlugin.IMAGE_LIBRARY_LIST);
    }

    @Override
    public Object[] getChildren(Object element) {

        try {

            LibraryListsNode libraryLists = (LibraryListsNode)element;
            IRapidFireJobResource resource = libraryLists.getJob();

            return resource.getParentSubSystem().getLibraryLists(resource.getDataLibrary(), resource.getName(), getShell());

        } catch (Exception e) {
            RapidFireCorePlugin.logError("*** Could resolve filter string and load library lists ***", e); //$NON-NLS-1$
            MessageDialogAsync.displayError(e.getLocalizedMessage());
        }

        return new Object[0];
    }

    @Override
    public String getType(Object element) {
        return Messages.NodeType_LibraryLists;
    }

    @Override
    public String getRemoteType(Object element) {
        return "node.library.lists"; //$NON-NLS-1$
    }

}