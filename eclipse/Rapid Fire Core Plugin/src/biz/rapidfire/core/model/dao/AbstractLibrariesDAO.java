/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Team
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.model.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.swt.widgets.Shell;

import biz.rapidfire.core.model.IRapidFireLibraryResource;

public abstract class AbstractLibrariesDAO {

    public static final String JOB = "JOB"; //$NON-NLS-1$
    public static final String LIBRARY = "LIBRARY"; //$NON-NLS-1$
    public static final String SHADOW_LIBRARY = "SHADOW_LIBRARY"; //$NON-NLS-1$

    private IBaseDAO dao;

    public AbstractLibrariesDAO(IBaseDAO dao) {

        this.dao = dao;
    }

    public List<IRapidFireLibraryResource> load(final String libraryName, String job, Shell shell) throws Exception {

        final List<IRapidFireLibraryResource> libraries = new ArrayList<IRapidFireLibraryResource>();

        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        if (!dao.checkRapidFireLibrary(shell, libraryName)) {
            return libraries;
        }

        try {

            String sqlStatement = getSqlStatement(libraryName);
            preparedStatement = dao.prepareStatement(sqlStatement, libraryName);
            preparedStatement.setString(1, job);
            resultSet = preparedStatement.executeQuery();
            resultSet.setFetchSize(50);

            if (resultSet != null) {
                while (resultSet.next()) {
                    libraries.add(produceLibrary(libraryName, resultSet));
                }
            }
        } finally {
            dao.destroy(preparedStatement);
            dao.destroy(resultSet);
        }

        return libraries;
    }

    private IRapidFireLibraryResource produceLibrary(String dataLibrary, ResultSet resultSet) throws SQLException {

        String job = resultSet.getString(JOB).trim();
        String library = resultSet.getString(LIBRARY).trim();

        IRapidFireLibraryResource libraryResource = createLibraryInstance(dataLibrary, job, library); //$NON-NLS-1$

        String shadowLibrary = resultSet.getString(SHADOW_LIBRARY).trim();

        libraryResource.setShadowLibrary(shadowLibrary);

        return libraryResource;
    }

    protected abstract IRapidFireLibraryResource createLibraryInstance(String libraryName, String job, String library);

    private String getSqlStatement(String libraryName) throws Exception {

        // @formatter:off
        String sqlStatement = 
        "SELECT " +
            "JOB, " +
            "LIBRARY, " +
            "SHADOW_LIBRARY " +
        "FROM " +
            IBaseDAO.LIBRARY +
            "LIBRARIES " +
        "WHERE " +
            "JOB = ?";
        // @formatter:on

        return dao.insertLibraryQualifier(sqlStatement, libraryName);
    }
}
