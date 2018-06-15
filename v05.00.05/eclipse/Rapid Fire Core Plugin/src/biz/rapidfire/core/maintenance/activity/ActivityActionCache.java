/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Owners
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.maintenance.activity;

import biz.rapidfire.core.maintenance.AbstractResourceActionsCache;
import biz.rapidfire.core.maintenance.activity.shared.ActivityAction;

public final class ActivityActionCache extends AbstractResourceActionsCache<KeyActivityActionCache, ActivityAction> {

    /**
     * The instance of this Singleton class.
     */
    protected static ActivityActionCache instance;

    /**
     * Thread-safe method that returns the instance of this Singleton class.
     */
    public synchronized static ActivityActionCache getInstance() {
        if (instance == null) {
            instance = new ActivityActionCache();
        }
        return instance;
    }

}
