#pragma rtGlobals=1		// Use modern global access method.

// TestSuite -- a component of IgorUnit
//   This data type can be used to organize tests into sets/suites

#ifndef IGORUNIT_TS
#define IGORUNIT_TS

#include "utils"

Structure TestSuite
    String groups
    Wave tests
    Variable test_no
EndStructure

Function TS_init(ts)
    STRUCT TestSuite &ts
    ts.test_no = 0
    ts.groups = ""
    TS_initTestWave(ts)
End

Static Function TS_initTestWave(ts)
    STRUCT TestSuite &ts

    Make/T/N=(0) ts.tests
    SetDimLabel 0,-1, test_groups, ts.tests
End

Function TS_addGroup(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    if (!TS_hasGroup(ts, groupname))
        ts.groups = AddListItem(groupname, ts.groups, ";", Inf)
        TS_initNewGroupTestList(ts)
    endif
    return TS_getGroupIndex(ts, groupname)
End

Static Function TS_initNewGroupTestList(ts)
    STRUCT TestSuite &ts

    Wave_appendRow(ts.tests)
    ts.tests[Inf] = ""
End

Function TS_addTest(ts, groupname, testname)
    STRUCT TestSuite &ts
    String groupname, testname

    Variable group_idx = TS_addGroup(ts, groupname)
    if (!TS_hasTest(ts, groupname, testname))
        Variable test_list = 
        ts.tests[group_idx] = AddListItem(testname, ts.tests[group_idx], ";", Inf)
        ts.test_no += 1
    endif
    return TS_getTestIndex(ts, groupname, testname)
End

Function TS_removeTest(ts, groupname, testname)
    STRUCT TestSuite &ts
    String testname

    if (TS_hasTest(ts, groupname, testname))
        Variable test_idx = TS_getTestIndex(ts, groupname, testname)
        ts.tests[group_idx] = RemoveListItem(test_idx, ts.tests[group_idx], ";")
        ts.test_no -= 1
    endif
End

Function/S TS_getGroupByIndex(ts, group_idx)
    STRUCT TestSuite &ts
    Variable group_idx

    String groupname = StringFromList(group_idx, ts.groups)
    return groupname
End

Function/S TS_getTestByIndex(ts, group_idx, test_idx)
    STRUCT TestSuite &ts
    Variable group_idx, test_idx

    String test_list = TS_getGroupTestsByIndex(ts, group_idx)
    String testname = StringFromList(test_idx, test_list)
    return testname
End

Function/S TS_getGroupTests(ts, groupname)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    String groupname

    Variable group_idx = TS_getGroupIndex(ts, groupname)
    return TS_getGroupTestsByIndex(ts, group_idx)
End

Function/S TS_getGroupTestsByIndex(ts, group_idx)
    // Return a list of tests in a given group
    STRUCT TestSuite &ts
    String group_idx

    return ts.tests[group_idx]
End

Function TS_hasGroup(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    if (TS_getGroupIndex(ts, groupname) > -1)
        return TRUE
    endif
    return FALSE
End

Function TS_hasTest(ts, groupname, testname)
    STRUCT TestSuite &ts
    String testname

    if (TS_getTestIndex(ts, groupname, testname) > -1)
        return TRUE
    endif
    return FALSE
End

Function TS_getGroupIndex(ts, groupname)
    STRUCT TestSuite &ts
    String groupname

    return WhichListItem(groupname, ts.groups, ";")
End

Function TS_getTestIndex(ts, groupname, testname)
    STRUCT TestSuite &ts
    String groupname, testname

    String test_list = TS_getGroupTests(ts, groupname)
    return WhichListItem(testname, test_list, ";")
End

Function TS_getTestCount(ts)
    STRUCT TestSuite &ts
    return ts.test_no
End

Function TS_getGroupCount(ts)
    STRUCT TestSuite &ts
    return ItemsInList(ts.groups)
End

Function TS_getGroupTestCount(ts, groupname)
    STRUCT TestSuite &ts
    return ItemsInList(TS_getGroupTests(ts, groupname))
End

Function Wave_appendRow(wave_in)
    // Add a new row to a wave and return the index of the new row
    Wave wave_in
    Variable rowCount = Wave_getRowCount(wave_in)
    InsertPoints/M=0 rowCount, 1, wave_in
    return Wave_getRowCount(wave_in)
End

Function Wave_getRowCount(wave_in)
    Wave wave_in
    return DimSize(wave_in, 0)
End

Function Wave2D_getColumnIndex(wave_in, onedim_index)
    // Return the column index in a 2D wave when given a 1D index
    Wave wave_in
    Variable onedim_index
    Variable row_count = Wave_getRowCount(wave_in)
    return floor(onedim_index / row_count)
End

Function Wave2D_getRowIndex(wave_in, onedim_index, col_index)
    // Return the row index in a 2D wave when given a 1D index
    Wave wave_in
    Variable onedim_index, col_index

    Variable row_count = Wave_getRowCount(wave_in)
    return (onedim_index - (col_index * row_count))
End

#endif