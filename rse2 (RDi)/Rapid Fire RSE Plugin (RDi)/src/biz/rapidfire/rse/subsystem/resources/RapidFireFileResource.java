/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Team
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.rse.subsystem.resources;

import org.eclipse.rse.core.subsystems.AbstractResource;
import org.eclipse.rse.core.subsystems.ISubSystem;

import biz.rapidfire.core.exceptions.IllegalParameterException;
import biz.rapidfire.core.helpers.StringHelper;
import biz.rapidfire.core.model.FileType;
import biz.rapidfire.core.model.IRapidFireFileResource;
import biz.rapidfire.core.subsystem.IRapidFireSubSystem;
import biz.rapidfire.core.subsystem.resources.RapidFireFileResourceDelegate;

public class RapidFireFileResource extends AbstractResource implements IRapidFireFileResource, Comparable<IRapidFireFileResource> {

    private RapidFireFileResourceDelegate delegate;

    public RapidFireFileResource(String dataLibrary, String job, int position) {

        if (StringHelper.isNullOrEmpty(dataLibrary)) {
            throw new IllegalParameterException("dataLibrary", dataLibrary); //$NON-NLS-1$
        }

        if (StringHelper.isNullOrEmpty(job)) {
            throw new IllegalParameterException("job", job); //$NON-NLS-1$
        }

        this.delegate = new RapidFireFileResourceDelegate(dataLibrary, job, position);
    }

    /*
     * IRapidFireResource methods
     */

    public String getDataLibrary() {
        return delegate.getDataLibrary();
    }

    public IRapidFireSubSystem getParentSubSystem() {
        return (IRapidFireSubSystem)super.getSubSystem();
    }

    public void setParentSubSystem(IRapidFireSubSystem subSystem) {
        super.setSubSystem((ISubSystem)subSystem);
    }

    /*
     * IRapidFireFileResource methods
     */

    public String getJob() {
        return delegate.getJob();
    }

    public int getPosition() {
        return delegate.getPosition();
    }

    public String getName() {
        return delegate.getName();
    }

    public void setName(String file) {
        delegate.setName(file);
    }

    public FileType getFileType() {
        return delegate.getFileType();
    }

    public void setFileType(FileType fileType) {
        delegate.setFileType(fileType);
    }

    public String getCopyProgramName() {
        return delegate.getCopyProgramName();
    }

    public void setCopyProgramName(String copyProgramName) {
        delegate.setCopyProgramName(copyProgramName);
    }

    public String getCopyProgramLibrary() {
        return delegate.getCopyProgramLibrary();
    }

    public void setCopyProgramLibrary(String copyProgramLibrary) {
        delegate.setCopyProgramLibrary(copyProgramLibrary);
    }

    public String getConversionProgramName() {
        return delegate.getConversionProgramName();
    }

    public void setConversionProgramName(String conversionProgramName) {
        delegate.setConversionProgramName(conversionProgramName);
    }

    public String getConversionProgramLibrary() {
        return delegate.getConversionProgramLibrary();
    }

    public void setConversionProgramLibrary(String conversionProgramLibrary) {
        delegate.setConversionProgramLibrary(conversionProgramLibrary);
    }

    public int compareTo(IRapidFireFileResource resource) {
        return delegate.compareTo(resource);
    }

    @Override
    public String toString() {
        return delegate.toString();
    }

}