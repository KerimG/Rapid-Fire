/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Team
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core;

import org.eclipse.osgi.util.NLS;

public class Messages extends NLS {

    private static final String BUNDLE_NAME = "biz.rapidfire.core.messages"; //$NON-NLS-1$

    public static final String EMPTY = ""; //$NON-NLS-1$
    public static final String SPACE = " "; //$NON-NLS-1$

    public static String E_R_R_O_R;

    // Dialog titles
    public static String Specify_a_filter;

    // Column headings
    public static String ColumnLabel_File;
    public static String ColumnLabel_Library;
    public static String ColumnLabel_Records_in_production_library;
    public static String ColumnLabel_Records_in_shadow_library;
    public static String ColumnLabel_Records_to_copy;
    public static String ColumnLabel_Records_copied;
    public static String ColumnLabel_Estimated_time;
    public static String ColumnLabel_Changes_to_apply;
    public static String ColumnLabel_Changes_applied;
    public static String ColumnLabel_Progress;

    // Dialog labels
    public static String Label_Library_colon;
    public static String Label_Job_colon;
    public static String Label_Status_colon;
    public static String Label_Full_generic_string;
    public static String Label_Enable_large_progress_bar;

    public static String Tooltip_Enable_large_progress_bar;

    // Action labels
    public static String ActionLabel_Auto_refresh_menu_item;
    public static String ActionLabel_Auto_refresh_menu_item_stop;
    public static String ActionLabel_Auto_refresh_menu_item_every_A_seconds;

    public static String ActionTooltip_Refresh;
    public static String ActionTooltip_Auto_refresh_menu_item_every_A_seconds;
    public static String ActionTooltip_Auto_refresh_menu_item_stop;

    // Property labels
    public static String Batch_job_name;
    public static String Batch_job_user;
    public static String Batch_job_number;

    public static String Tooltip_Batch_job_name;
    public static String Tooltip_Batch_job_user;
    public static String Tooltip_Batch_job_number;

    // Job labels
    public static String JobLabel_Refreshing_file_copy_statuses;

    // Error messages
    public static String Library_name_A_is_not_valid;
    public static String The_library_name_must_be_specified;
    public static String The_job_name_must_be_specified;
    public static String The_job_status_must_be_specified;
    public static String Rapid_Fire_library_A_on_system_B_is_of_version_C_but_at_least_version_D_is_required_Please_update_the_Rapid_Fire_library;
    public static String The_installed_Rapid_Fire_plug_in_version_A_is_outdated_because_the_installed_Rapid_Fire_library_requires_at_least_version_B_of_the_Rapid_Fire_plug_in_Please_update_your_Rapid_Fire_plug_in;
    public static String Rapid_Fire_library_A_does_not_exist_on_system_B_Please_install_Rapid_Fire_library_A_on_system_B;
    public static String The_specified_library_A_on_system_B_is_not_a_Rapid_Fire_library;

    private Messages() {
    }

    static {
        // initialize resource bundle
        NLS.initializeMessages(BUNDLE_NAME, Messages.class);
    }
}
