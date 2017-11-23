/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Owners
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.model.maintenance.library;

import java.sql.CallableStatement;
import java.sql.Types;

import biz.rapidfire.core.Messages;
import biz.rapidfire.core.model.dao.IJDBCConnection;
import biz.rapidfire.core.model.maintenance.AbstractManager;
import biz.rapidfire.core.model.maintenance.Result;
import biz.rapidfire.core.model.maintenance.Success;
import biz.rapidfire.core.model.maintenance.job.IJobInitialize;
import biz.rapidfire.core.model.maintenance.job.JobKey;

public class LibraryManager extends AbstractManager<LibraryKey, LibraryValues> {

    private static final String ERROR_001 = "001"; //$NON-NLS-1$
    private static final String ERROR_002 = "002"; //$NON-NLS-1$
    private static final String ERROR_003 = "003"; //$NON-NLS-1$

    private static final String EMPTY_STRING = ""; //$NON-NLS-1$
    private IJDBCConnection dao;
    private JobKey jobKey;

    public LibraryManager(IJDBCConnection dao) {
        this.dao = dao;
    }

    @Override
    public void openFiles() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIB_openFiles\"()}")); //$NON-NLS-1$ //$NON-NLS-2$
        statement.execute();
    }

    @Override
    public Result initialize(String mode, LibraryKey key) throws Exception {

        jobKey = new JobKey(key.getJobName());

        CallableStatement statement = dao.prepareCall(dao
            .insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIB_initialize\"(?, ?, ?, ?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibraryInitialize.MODE, mode);
        statement.setString(ILibraryInitialize.JOB, key.getJobName());
        statement.setString(ILibraryInitialize.LIBRARY, key.getLibrary());
        statement.setString(ILibraryInitialize.SUCCESS, Success.NO.label());
        statement.setString(ILibraryInitialize.ERROR_CODE, EMPTY_STRING);

        statement.registerOutParameter(ILibraryInitialize.SUCCESS, Types.CHAR);
        statement.registerOutParameter(ILibraryInitialize.ERROR_CODE, Types.CHAR);

        statement.execute();

        // TODO: add error handling
        String success = statement.getString(ILibraryInitialize.SUCCESS);
        String errorCode = statement.getString(IJobInitialize.ERROR_CODE);

        String message;
        if (Success.YES.label().equals(success)) {
            message = ""; //$NON-NLS-1$
        } else {
            message = Messages.bind(Messages.Could_not_initialize_library_manager_for_library_C_of_job_A_in_library_B,
                new Object[] { key.getJobName(), dao.getLibraryName(), key.getLibrary(), getErrorMessage(errorCode) });
        }

        Result status = new Result(null, message, success);

        return status;
    }

    /**
     * Translates the API error code to message text.
     * 
     * @param errorCode - Error code that was returned by the API.
     * @return message text
     */
    private String getErrorMessage(String errorCode) {

        // TODO: use reflection
        if (ERROR_001.equals(errorCode)) {
            return Messages.LibraryManager_001;
        } else if (ERROR_002.equals(errorCode)) {
            return Messages.LibraryManager_002;
        } else if (ERROR_003.equals(errorCode)) {
            return Messages.LibraryManager_003;
        }

        return Messages.bind(Messages.EntityManager_Unknown_error_code_A, errorCode);
    }

    @Override
    public LibraryValues getValues() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIB_getValues\"(?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibraryGetValues.LIBRARY, EMPTY_STRING);
        statement.setString(ILibraryGetValues.SHADOW_LIBRARY, EMPTY_STRING);

        statement.registerOutParameter(ILibraryGetValues.LIBRARY, Types.CHAR);
        statement.registerOutParameter(ILibraryGetValues.SHADOW_LIBRARY, Types.CHAR);

        statement.execute();

        LibraryValues values = new LibraryValues();
        values.setKey(new LibraryKey(jobKey, statement.getString(ILibraryGetValues.LIBRARY)));
        values.setShadowLibrary(statement.getString(ILibraryGetValues.SHADOW_LIBRARY));

        return values;
    }

    @Override
    public void setValues(LibraryValues values) throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIB_setValues\"(?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibrarySetValues.LIBRARY, values.getKey().getLibrary());
        statement.setString(ILibrarySetValues.SHADOW_LIBRARY, values.getShadowLibrary());

        statement.execute();
    }

    @Override
    public Result check() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIB_check\"(?, ?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibraryCheck.FIELD_NAME, EMPTY_STRING);
        statement.setString(ILibraryCheck.MESSAGE, EMPTY_STRING);
        statement.setString(ILibraryCheck.SUCCESS, Success.NO.label());

        statement.registerOutParameter(1, Types.CHAR);
        statement.registerOutParameter(2, Types.CHAR);
        statement.registerOutParameter(3, Types.CHAR);

        statement.execute();

        String fieldName = statement.getString(ILibraryCheck.FIELD_NAME);
        String message = statement.getString(ILibraryCheck.MESSAGE);
        String success = statement.getString(ILibraryCheck.SUCCESS);

        return new Result(fieldName, message, success);
    }

    @Override
    public void book() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIB_book\"()}")); //$NON-NLS-1$ //$NON-NLS-2$
        statement.execute();
    }

    @Override
    public void closeFiles() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIB_closeFiles\"()}")); //$NON-NLS-1$ //$NON-NLS-2$
        statement.execute();
    }

}