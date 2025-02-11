// Copyright 2019, Oracle Corporation and/or its affiliates.  All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.

package com.oracle.weblogic.imagetool.logging;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

public class LoggingFactory {
    // map from resourceBundleName to facade
    private static final Map<String, LoggingFacade> facade = new HashMap<>();

    private LoggingFactory() {
        // hide implicit public constructor
    }

    /**
     * Obtains a Logger from the underlying logging implementation and wraps it in a LoggingFacade.
     * Infers caller class and bundle name.
     *
     * @param clazz use class name as logger name
     * @return a PlatformLogger object for the caller to use
     */
    public static LoggingFacade getLogger(Class clazz) {
        return getLogger(clazz.getName(), "ImageTool");
    }

    /**
     * Obtains a Logger from the underlying logging implementation and wraps it in a LoggingFacade.
     * Infers caller class and bundle name.
     *
     * @param name logger name
     * @return a PlatformLogger object for the caller to use
     */
    public static LoggingFacade getLogger(String name) {
        return getLogger(name, "ImageTool");
    }

    /**
     * Obtains a Logger from the underlying logging implementation and wraps it in a LoggingFacade.
     *
     * @param name the name of the logger to use
     * @param resourceBundleName the resource bundle to use with this logger
     * @return a PlatformLogger object for the caller to use
     */
    public static synchronized LoggingFacade getLogger(String name, String resourceBundleName) {

        LoggingFacade lf = facade.get(resourceBundleName);
        if (lf == null) {
            Logger logger = Logger.getLogger(name, resourceBundleName);
            lf = new LoggingFacade(logger);
            facade.put(resourceBundleName, lf);
        }

        return lf;
    }
}
