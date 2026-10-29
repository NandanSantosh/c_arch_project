/**
 * File Name: f_d_formats.cpp
 * Author: Vishank Singh
 * Github: https://github.com/VishankSingh
 */

#include "assembler/parser.h"
#include "common/instructions.h"
#include "common/rounding_modes.h"
#include "utils/utils.h"
#include "processor/registers.h"
#include <string>

namespace Kites
{
bool Parser::parse_O_VPR_C_VPR_C_VPR()
{
    if (peekToken(1).line_number == currentToken().line_number &&
        peekToken(1).type == TokenType::VP_REGISTER &&
        peekToken(2).line_number == currentToken().line_number &&
        peekToken(2).type == TokenType::COMMA &&
        peekToken(3).line_number == currentToken().line_number &&
        peekToken(3).type == TokenType::VP_REGISTER &&
        peekToken(4).line_number == currentToken().line_number &&
        peekToken(4).type == TokenType::COMMA &&
        peekToken(5).line_number == currentToken().line_number &&
        peekToken(5).type == TokenType::VP_REGISTER &&
        (peekToken(6).type == TokenType::EOF_ ||
         peekToken(6).line_number != currentToken().line_number))
    {
        ICUnit block;
        block.setOpcode(currentToken().value);
        block.setLineNumber(currentToken().line_number);
        block.setInstructionIndex(instruction_index_);

        std::string reg;
        reg = reg_alias_to_name.at(peekToken(1).value);
        block.setRd(reg);
        reg = reg_alias_to_name.at(peekToken(3).value);
        block.setRs1(reg);
        reg = reg_alias_to_name.at(peekToken(5).value);
        block.setRs2(reg);

        skipCurrentLine();
        intermediate_code_.emplace_back(block, true);
        instruction_number_line_number_mapping_[instruction_index_] = block.getLineNumber();
        instruction_index_++;
        return true;
    }
    return false;

}


bool Parser::parse_O_VPR_C_I_LP_GPR_RP()
{
    if (peekToken(1).line_number == currentToken().line_number &&
        peekToken(1).type == TokenType::VP_REGISTER &&
        peekToken(2).line_number == currentToken().line_number &&
        peekToken(2).type == TokenType::COMMA &&
        peekToken(3).line_number == currentToken().line_number &&
        peekToken(3).type == TokenType::NUM &&
        peekToken(4).line_number == currentToken().line_number &&
        peekToken(4).type == TokenType::LPAREN &&
        peekToken(5).line_number == currentToken().line_number &&
        peekToken(5).type == TokenType::GP_REGISTER &&
        peekToken(6).line_number == currentToken().line_number &&
        peekToken(6).type == TokenType::RPAREN &&
        (peekToken(7).type == TokenType::EOF_ ||
         peekToken(7).line_number != currentToken().line_number))
    {
        ICUnit block;
        block.setOpcode(currentToken().value);
        block.setLineNumber(currentToken().line_number);
        block.setInstructionIndex(instruction_index_);
        std::string reg;

        if (instruction_set::isValidSVTypeInstruction(block.getOpcode()))
        {
            // VSD source vector register: vsd v3, 16(x10)
            block.setRs2(reg_alias_to_name.at(peekToken(1).value));

            int64_t imm = std::stoll(peekToken(3).value);

            if (imm < -2048 || imm > 2047)
            {
                recordError(ParseError(
                    peekToken(3).line_number,
                    "Immediate value out of range"));

                errors_.all_errors.emplace_back(
                    errors::ImmediateOutOfRangeError(
                        "Immediate value out of range",
                        "Expected: -2048 <= imm <= 2047",
                        filename_,
                        peekToken(3).line_number,
                        peekToken(3).column_number,
                        GetLineFromFile(
                            filename_, peekToken(3).line_number)));

                skipCurrentLine();
                return true;
            }

            block.setImm(std::to_string(imm));

            // GPR base register
            block.setRs1(reg_alias_to_name.at(peekToken(5).value));
        }
         else if (instruction_set::isValidLVTypeInstruction(block.getOpcode()))
        {
            reg = reg_alias_to_name.at(peekToken(1).value);
            block.setRd(reg);
            int64_t imm = std::stoll(peekToken(3).value);
            if (-2048 <= imm && imm <= 2047)
            {
                block.setImm(std::to_string(imm));
            }
            else
            {
                recordError(ParseError(peekToken(3).line_number, "Immediate value out of range"));
                errors_.all_errors.emplace_back(errors::ImmediateOutOfRangeError(
                    "Immediate value out of range", "Expected: -2048 <= imm <= 2047", filename_,
                    peekToken(3).line_number, peekToken(3).column_number,
                    GetLineFromFile(filename_, peekToken(3).line_number)));
                skipCurrentLine();
                return true;
            }
            reg = reg_alias_to_name.at(peekToken(5).value);
            block.setRs1(reg);
        }



        else
        {
            return false;
        }

        skipCurrentLine();
        intermediate_code_.emplace_back(block, true);
        instruction_number_line_number_mapping_[instruction_index_] =
            block.getLineNumber();
        instruction_index_++;

        return true;
    }

    return false;
}

}//namespace Kites
