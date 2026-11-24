#include "profiler/profiler.h"
#include "common/instructions.h"
#include <fstream>

namespace Kites
{

namespace instr = instruction_set;

Profiler::Profiler(QObject *parent) : QObject(parent)
{
}

void Profiler::Reset()
{
    m_lineNumberToExecutionCounts.clear();
    m_instructionTypeCounts.fill(0);

    // New: reset dynamic mnemonic counts
    m_mnemonicExecutionCounts.clear();

    emit profilerReset();
}

void Profiler::setInstructionToLineMapping(const AssembledProgram &program)
{
    m_instructionNumberToLineNumber = program.instruction_number_line_number_mapping;
}

void Profiler::setInstructionToMnemonicMapping(const AssembledProgram &program)
{
    m_instructionNumberToMnemonic.clear();

    for (unsigned int i = 0; i < program.intermediate_code.size(); i++)
    {
        const auto &icUnit = program.intermediate_code[i].first;

        m_instructionNumberToMnemonic[i] = icUnit.getOpcode();
    }
}
// void Profiler::setInstructionTypeCounts(const AssembledProgram &program)
// {
//     m_instructionTypeCounts.fill(0);
//     for (const auto &[icUnit, _] : program.intermediate_code)
//     {
//         const auto mnemonic = icUnit.getOpcode();
//         if (!mnemonic.empty())
//         {
//             instr::InstructionType instrType = instr::getInstructionType(mnemonic);
//             m_instructionTypeCounts[toIndex(instrType)]++;
//         }
//     }
//     emit updateInstructionTypeCountsSignal(m_instructionTypeCounts);
// }

const InstructionTypeCounts &Profiler::getInstructionTypeCounts() const
{
    return m_instructionTypeCounts;
}

const std::map<std::string, uint64_t>&
Profiler::getMnemonicExecutionCounts() const
{
    return m_mnemonicExecutionCounts;
}

void Profiler::exportMnemonicCountsToCSV(const std::string &filename) const
{
    std::ofstream file(filename);

    if (!file.is_open())
    {
        qDebug() << "Could not open CSV file:"
                 << QString::fromStdString(filename);
        return;
    }

    file << "Mnemonic,Execution_Count\n";

    for (const auto &[mnemonic, count] : m_mnemonicExecutionCounts)
    {
        file << mnemonic << "," << count << "\n";
    }

    file.close();

    qDebug() << "Mnemonic counts exported to:"
             << QString::fromStdString(filename);
}

int Profiler::getLineExecutionCount(int lineNumber) const
{
    const auto it = m_lineNumberToExecutionCounts.find(lineNumber);
    if (it != m_lineNumberToExecutionCounts.end())
    {
        return it->second;
    }
    return 0;
}

void Profiler::setLineNumberToInstructionTypeMapping(const AssembledProgram &program)
{
    m_lineNumberToinstructionType.clear();
    qDebug() << "Setting line number to instruction type mapping for program" ;
    for (const auto &[icUnit, _] : program.intermediate_code)
    {
        const auto lineNumber = icUnit.getLineNumber();
        const auto mnemonic = icUnit.getOpcode();
        if (!mnemonic.empty())
        {
            instr::InstructionType instrType = instr::getInstructionType(mnemonic);
            m_lineNumberToinstructionType[lineNumber] = instrType;
            m_instructionTypeCounts[toIndex(instrType)]++;
        }
    }
    emit updateLineInstructionTypeSignal(m_lineNumberToinstructionType);
}

void Profiler::processorClockedSlot(const ProcessorState &processorState)
{
    unsigned int instructionNumber =
        static_cast<unsigned int>(processorState.lastExecutedPC / 4);

    // Existing line profiling
    auto lineIt = m_instructionNumberToLineNumber.find(instructionNumber);

    if (lineIt == m_instructionNumberToLineNumber.end())
        return;

    int executedLine = lineIt->second;

    emit incrementLineExecutionCountSignal(executedLine);

    // New: dynamic mnemonic counting
    auto mnemonicIt = m_instructionNumberToMnemonic.find(instructionNumber);

    if (mnemonicIt != m_instructionNumberToMnemonic.end())
    {
        m_mnemonicExecutionCounts[mnemonicIt->second]++;

    }
}

// uint64_t Profiler::resolveExecutedLineFromState(const ProcessorState& processorState) const
// {
//     if (processorState.programCounters.empty())
//     {
//         return -1; // No program counters available
//     }

//     uint64_t programCounter = processorState.programCounters[0];
//     unsigned int instructionNumber = static_cast<unsigned int>(programCounter / 4);

//     const auto it = m_instructionNumberToLineNumber.find(instructionNumber);
//     if (it != m_instructionNumberToLineNumber.end())
//     {
//         return static_cast<int>(it->second);
//     }
//     return -1; // Not found
// }

instr::InstructionType Profiler::getInstructionTypeForLine(int lineNumber) const
{
    const auto it = m_lineNumberToinstructionType.find(lineNumber);
    if (it != m_lineNumberToinstructionType.end())
    {
        return it->second;
    }
    return instr::InstructionType::UNKNOWN;
}
}//namespace Kites
