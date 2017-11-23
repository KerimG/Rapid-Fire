/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Owners
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.model.maintenance.librarylist;

import java.sql.CallableStatement;
import java.sql.Types;

import biz.rapidfire.core.Messages;
import biz.rapidfire.core.model.dao.IJDBCConnection;
import biz.rapidfire.core.model.maintenance.AbstractManager;
import biz.rapidfire.core.model.maintenance.Result;
import biz.rapidfire.core.model.maintenance.Success;
import biz.rapidfire.core.model.maintenance.job.JobKey;

public class LibraryListManager extends AbstractManager<LibraryListKey, LibraryListValues> {

    private static final String ERROR_001 = "001"; //$NON-NLS-1$
    private static final String ERROR_002 = "002"; //$NON-NLS-1$
    private static final String ERROR_003 = "003"; //$NON-NLS-1$

    private static final String EMPTY_STRING = ""; //$NON-NLS-1$
    private IJDBCConnection dao;
    private JobKey jobKey;

    public LibraryListManager(IJDBCConnection dao) {
        this.dao = dao;
    }

    @Override
    public void openFiles() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIBL_openFiles\"()}")); //$NON-NLS-1$ //$NON-NLS-2$
        statement.execute();
    }

    @Override
    public Result initialize(String mode, LibraryListKey key) throws Exception {

        jobKey = new JobKey(key.getJobName());

        CallableStatement statement = dao.prepareCall(dao
            .insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIBL_initialize\"(?, ?, ?, ?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibraryListInitialize.MODE, mode);
        statement.setString(ILibraryListInitialize.JOB, key.getJobName());
        statement.setString(ILibraryListInitialize.LIBRARY_LIST, key.getLibraryList());
        statement.setString(ILibraryListInitialize.SUCCESS, Success.NO.label());
        statement.setString(ILibraryListInitialize.ERROR_CODE, EMPTY_STRING);

        statement.registerOutParameter(ILibraryListInitialize.SUCCESS, Types.CHAR);
        statement.registerOutParameter(ILibraryListInitialize.ERROR_CODE, Types.CHAR);

        statement.execute();

        // TODO: add error handling
        String success = statement.getString(ILibraryListInitialize.SUCCESS);
        String errorCode = statement.getString(ILibraryListInitialize.ERROR_CODE);

        String message;
        if (Success.YES.label().equals(success)) {
            message = ""; //$NON-NLS-1$
        } else {
            message = Messages.bind(Messages.Could_not_initialize_library_list_manager_for_library_list_C_of_job_A_in_library_B,
                new Object[] { key.getJobName(), dao.getLibraryName(), key.getLibraryList(), getErrorMessage(errorCode) });
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
            return Messages.LibraryListManager_001;
        } else if (ERROR_002.equals(errorCode)) {
            return Messages.LibraryListManager_002;
        } else if (ERROR_003.equals(errorCode)) {
            return Messages.LibraryListManager_003;
        }

        return Messages.bind(Messages.EntityManager_Unknown_error_code_A, errorCode);
    }

    @Override
    public LibraryListValues getValues() throws Exception {

        CallableStatement statement = dao.prepareCall(dao
            .insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIBL_getValues\"(?, ?, ?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibraryListGetValues.LIBRARY_LIST, EMPTY_STRING);
        statement.setString(ILibraryListGetValues.DESCRIPTION, EMPTY_STRING);
        statement.setString(ILibraryListGetValues.SEQUENCE_NUMBERS, EMPTY_STRING);
        statement.setString(ILibraryListGetValues.LIBRARIES, EMPTY_STRING);

        statement.registerOutParameter(ILibraryListGetValues.LIBRARY_LIST, Types.CHAR);
        statement.registerOutParameter(ILibraryListGetValues.DESCRIPTION, Types.CHAR);
        statement.registerOutParameter(ILibraryListGetValues.SEQUENCE_NUMBERS, Types.CHAR);
        statement.registerOutParameter(ILibraryListGetValues.LIBRARIES, Types.CHAR);

        statement.execute();

        LibraryListValues values = new LibraryListValues();
        values.setKey(new LibraryListKey(jobKey, statement.getString(ILibraryListGetValues.LIBRARY_LIST)));
        values.setDescription(statement.getString(ILibraryListGetValues.DESCRIPTION));

        String sequencenNumbers = statement.getString(ILibraryListGetValues.SEQUENCE_NUMBERS);
        String libraries = statement.getString(ILibraryListGetValues.LIBRARY_LIST);
        values.setLibraryList(sequencenNumbers, libraries);

        return values;
    }

    @Override
    public void setValues(LibraryListValues values) throws Exception {

        CallableStatement statement = dao.prepareCall(dao
            .insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIBL_setValues\"(?, ?, ?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibraryListSetValues.LIBRARY_LIST, values.getKey().getLibraryList());
        statement.setString(ILibraryListSetValues.DESCRIPTION, values.getDescription());
        statement.setString(ILibraryListSetValues.SEQUENCE_NUMBERS, values.getSequenceNumberAsString());
        statement.setString(ILibraryListSetValues.LIBRARIES, values.getLibraryListAsString());

        statement.execute();
    }

    @Override
    public Result check() throws Exception {

        CallableStatement statement = dao.prepareCall(dao
            .insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIBL_check\"(?, ?, ?, ?)}")); //$NON-NLS-1$ //$NON-NLS-2$

        statement.setString(ILibraryListCheck.FIELD_NAME, EMPTY_STRING);
        statement.setFloat(ILibraryListCheck.RECORD, 0);
        statement.setString(ILibraryListCheck.MESSAGE, EMPTY_STRING);
        statement.setString(ILibraryListCheck.SUCCESS, Success.NO.label());

        statement.registerOutParameter(ILibraryListCheck.FIELD_NAME, Types.CHAR);
        statement.registerOutParameter(ILibraryListCheck.RECORD, Types.FLOAT);
        statement.registerOutParameter(ILibraryListCheck.MESSAGE, Types.CHAR);
        statement.registerOutParameter(ILibraryListCheck.SUCCESS, Types.CHAR);

        statement.execute();

        String fieldName = statement.getString(ILibraryListCheck.FIELD_NAME);
        float record = statement.getFloat(ILibraryListCheck.RECORD);
        String message = statement.getString(ILibraryListCheck.MESSAGE);
        String success = statement.getString(ILibraryListCheck.SUCCESS);

        return new Result(fieldName, record, message, success);
    }

    @Override
    public void book() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIBL_book\"()}")); //$NON-NLS-1$ //$NON-NLS-2$
        statement.execute();
    }

    @Override
    public void closeFiles() throws Exception {

        CallableStatement statement = dao.prepareCall(dao.insertLibraryQualifier("{CALL " + IJDBCConnection.LIBRARY + "\"MNTLIBL_closeFiles\"()}")); //$NON-NLS-1$ //$NON-NLS-2$
        statement.execute();
    }
}