---
layout: default
---

<pre>
Summary of important user-visible changes for version 5 (2019-02-23):
--------------------------------------------------------------------

 ** The determination of an object's dimensions, size, and shape by the
    functions ndims, rows, columns, isscalar, isvector, isrow, iscolumn,
    ismatrix, and issquare now fully depends on the function size.
    Thus, any user-defined object can ensure correct treatment by the
    aforementioned functions by properly overloading the "size"
    function.

 ** The function randi has been recoded to produce an unbiased (all
    results are equally likely) sample of integers.  This may produce
    different results in existing code.  If it is necessary to reproduce
    the exact random integer sequence as in previous versions use

      ri = imin + floor ((imax - imin + 1) * rand ());

 ** A new core function movfun will apply a function to a sliding
    window of arbitrary size on a dataset and accumulate the results.
    Many common cases have been implemented using the naming
    scheme movXXX where "XXX" is the function that will be applied.
    For example, the moving average over a dataset is movmean.
    New moving window functions:

    movfun   movslice
    movmad   movmax   movmean   movmedian   movmin   movprod
    movstd   movsum   movvar

 ** The functions issymmetric and ishermitian accept an option "nonskew"
    or "skew" to calculate the symmetric or skew-symmetric property
    of a matrix.  Performance has also been increased.

 ** The function isdefinite now returns true or false rather than
    -1, 0, 1.  To test for a positive semi-definite matrix (old output
    of 0) check whether the following two conditions hold:

      isdefinite (A) => 0
      isdefinite (A + 5*TOL, TOL) => 1

 ** The issorted function now uses a direction option of "ascend" or
    "descend" to make it compatible with both the sort function and
    with Matlab.  Change all uses of "ascending" and "descending" in
    existing code to the new options.

 ** The strncmp and strncmpi functions now return true if the two input
    strings match, even though the number of characters specified by N
    exceeds the string length.  This behavior more closely matches
    common sense and is Matlab compatible.  Example:

      Octave 5   : strncmp ("abc", "abc", 100) => true
      Previously : strncmp ("abc", "abc", 100) => false

 ** The intmax, intmin, and flintmax functions now accept a variable
    as input.  This supports a common programming usage which is to
    query the range of an existing variable.  Existing code can be
    simplified by removing the call to "class" that was previously
    required.  Example:

                   x = int8 (3);
      Octave 5   : range = [ intmin(x), intmax(x) ]
      Previously : range = [ intmin(class(x)), intmax(class(x)) ]

 ** The ranks function has been recoded for performance and is now 25X
    faster.  In addition, it now supports a third argument that
    specifies how to resolve the ranking of tie values.

 ** The fsolve function has been tweaked to use larger step sizes when
    calculating the Jacobian of a function with finite differences.
    This leads to faster convergence.  The default solver options have
    also changed to be Matlab compatible.  This *may* result in existing
    code producing different results.

          Option     |  New Default   |  Old Default
      ------------------------------------------------
        FinDiffType  |   "forward"    |   "central"
        MaxFunEvals  | 100*length(x0) |     Inf
        TolFun       |     1e-6       |     1e-7
        TolX         |     1e-6       |     1e-7
        Updating     |     "off"      |     "on"

 ** The fminsearch function has changed default solver options for
    Matlab compatibility.  The accuracy option TolFun is now 1e-4 rather
    than 1e-7.  This *may* result in existing code producing different
    results.

 ** The fminbnd function has changed defaults for Matlab compatibility.
    This *may* result in existing code producing different results.

          Option     |  New Default   |  Old Default
      ------------------------------------------------
        MaxFunEvals  |      500       |     Inf
        MaxIter      |      500       |     Inf
        TolX         |     1e-4       |     1e-8

 ** The fminunc function has changed defaults for Matlab compatibility.
    This *may* result in existing code producing different results.

          Option     |  New Default   |  Old Default
      ------------------------------------------------
        FinDiffType  |   "forward"    |   "central"
        MaxFunEvals  | 100*length(x0) |     Inf
        TolX         |     1e-6       |     1e-7
        TolFun       |     1e-6       |     1e-7

 ** Using "clear" with no arguments now removes only local variables
    from the current workspace.  Global variables will no longer be
    visible, but they continue to exist in the global workspace and
    possibly other workspaces such as the base workspace.
    This change was made for Matlab compatibility.

 ** The Octave plotting system now supports high resolution screens,
    i.e, those with greater than 96 DPI which are referred to as
    HiDPI/Retina monitors.

 ** Figure graphic objects have a new property "Number" which is
    read-only and will return the handle (number) of the figure.
    However, if the property "IntegerHandle" has been set to "off" then
    the property will return an empty matrix ([]).

 ** Patch and surface graphic objects now use the "FaceNormals" property
    for flat lighting.

 ** "FaceNormals" and "VertexNormals" for patch and surface graphic
    objects are now calculated only when necessary to improve graphics
    performance.  In order for any normals to be calculated the
    "FaceLighting" property must be set to "flat" (FaceNormals) or
    "gouraud" (VertexNormals), AND a light object must be present in the
    axes.

 ** The "Margin" property of text() objects has a new default of 3
    rather than 2.  This change was made for Matlab compatibility.

 ** Printing to raster formats (bitmaps like PNG or JPEG) now uses an
    OpenGL-based method by default.  The print options "-opengl"
    (raster) and "-painters" (vector) have been added ("qt" toolkit
    only).  The figure property "renderer" specifies which renderer to
    use.  When the property "renderermode" is "auto" Octave will select
    -opengl for a raster output format and -painters for a vector output
    format.

 ** A new print option "-RGBImage" has been added which captures the
    pixels of a figure as an image.  This is similar to screen capture
    tools, except that print formatting options can be used to, for
    example, change the resolution or display the image in black and
    white.

 ** Two new print options for page-based formats (PDF, PostScript) have
    been added.  The "-fillpage" option will stretch the plot to occupy
    the entire page with 0.25 inch margins all around.  The "-bestfit"
    option will expand the plot to take up as much room as possible on
    the page without distorting the original aspect ratio of the plot.

 ** Printing using the -dtiff output device will now create compressed
    images using LZW compression.  This change was made for Matlab
    compatibility.  To produce uncompressed images use the -dtiffn
    device.

 ** A new printing device is available, -ddumb, which produces ASCII art
    for plots.  This device is only available with the gnuplot toolkit.

 ** Specifying legend position with a numeric argument is deprecated and
    will be removed in Octave 7.0.  Use a string argument instead.

 ** It is now possible to use files and folders containing Unicode
    characters in Windows.

 ** The environment variable used by mkoctfile for linker flags is now
    LDFLAGS rather than LFLAGS.  LFLAGS is deprecated, and a warning
    is emitted if is used, but it will continue to work until eventual
    removal in Octave 7.0.

 ** The GUI requires Qt libraries.  The minimum Qt4 version supported is
    Qt4.8.  Qt5 of any version is preferred.

 ** The FFTW library is now required to perform FFT calculations.
    The FFTPACK sources have been removed from Octave.

 ** The OSMesa library is no longer used.  To print invisible figures
    when using OpenGL graphics, the Qt QOFFSCREENSURFACE feature must be
    available and you must use the qt graphics toolkit.

 ** The str2func function no longer accepts a second "global" argument.
    This argument was typically used to allow functions that accept
    function names as arguments to avoid conflicts with subfunctions or
    nested functions.  Instead, it's best to avoid this situation
    entirely and require users to pass function handles rather than
    function names.

 ** The path handling functions no longer perform variable or brace
    expansion on path elements and Octave's load-path is no longer
    subject to these expansions.

 ** New functions added in 5:

      clearvars
      isfile
      isfolder
      matlab.lang.makeUniqueStrings
      matlab.lang.makeValidName
      movegui
      movfun
      movie
      movmad
      movmax
      movmean
      movmedian
      movmin
      movprod
      movslice
      movstd
      movsum
      movvar
      openfig
      ordeig
      savefig
      uitable

 ** Legacy functions.

    The following functions have been declared legacy functions which
    means they are obsolete and should not be used in any new code.
    Unlike deprecated functions, however, their removal from Octave has
    not yet been scheduled.

      Function             | Replacement
      ---------------------|------------------
      findstr              | strfind
      flipdim              | flip
      isdir                | isfolder or dir_in_loadpath
      isequalwithequalnans | isequaln
      isstr                | ischar
      setstr               | char
      strmatch             | strncmp or strcmp
      strread              | textscan
      textread             | textscan

 ** Deprecated functions.

    The following functions have been deprecated in Octave 5 and will
    be removed from Octave 7 (or whatever version is the second major
    release after 5):

      Function               | Replacement
      -----------------------|------------------
      output_max_field_width | output_precision

 ** The following functions were deprecated in Octave 4.2 and have been
    removed from Octave 5.

      Function             | Replacement
      ---------------------|------------------
      bitmax               | flintmax
      mahalanobis          | mahal in Octave Forge statistics pkg
      md5sum               | hash
      octave_config_info   | __octave_config_info__
      onenormest           | normest1
      sleep                | pause
      usleep               | pause
      wavread              | audioread
      wavwrite             | audiowrite

 ** Deprecated graphics properties.

    The following properties or allowed corresponding values have been
    deprecated in Octave 5 and will be removed from Octave 7 (or
    whatever version is the second major release after 5):

      Object               | Property                | Value
      ---------------------|-------------------------|-------------------
      text                 | fontangle               | "oblique"
      uibuttongroup        | fontangle               | "oblique"
      uicontrol            | fontangle               | "oblique"
      uipanel              | fontangle               | "oblique"
      uitable              | fontangle               | "oblique"

 ** The following properties or allowed corresponding values were
    deprecated in Octave 4.2 and have been removed from Octave 5:

      Object               | Property                | Value
      ---------------------|-------------------------|-------------------
      axes                 | xaxislocation           | "zero"
                           | yaxislocation           | "zero"
      hggroup              | erasemode               |
      image                | erasemode               |
      line                 | erasemode               |
      patch                | erasemode               |
      patch                | normalmode              |
      surface              | erasemode               |
      surface              | normalmode              |
      text                 | erasemode               |

 ** The C++ function is_keyword has been deprecated in favor of
    iskeyword.  The old function will be removed two versions after 5.

---------------------------------------------------------

See NEWS.4 for old news.
</pre>