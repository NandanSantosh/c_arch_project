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

}//namespace Kites
