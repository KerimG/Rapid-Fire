/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Owners
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.model.maintenance.library;

import biz.rapidfire.core.model.maintenance.ICheck;

public interface ILibraryCheck extends ICheck {

    public static final String FIELD_JOB = "JOB"; //$NON-NLS-1$
    public static final String FIELD_LIBRARY = "LIB"; //$NON-NLS-1$
    public static final String FIELD_SHADOW_LIBRARY = "SLIB"; //$NON-NLS-1$
}