import React, { useState } from "react";
import {
  Box,
  Typography,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
} from "@mui/material";
import NewUser from "./NewUser";

const SettingUsers = () => {
  const [open, setOpen] = useState(false);

  return (
    <Box sx={{ width: "90%", margin: "auto", mt: 4 }}>
      {/* Header */}
      <Box
        sx={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          mb: 2,
        }}
      >
        <Box>
          <Typography variant="h6" fontWeight="bold">
            User Detail
          </Typography>
          <Typography variant="subtitle2" color="gray">
            your name, profile picture etc.
          </Typography>
        </Box>
        <Button
          variant="text"
          sx={{ color: "green", fontWeight: "bold" }}
          onClick={() => setOpen(true)}
        >
          + Add New
        </Button>
      </Box>

      {/* Table */}
      <TableContainer component={Paper} sx={{ borderRadius: 2 }}>
        <Table>
          <TableHead>
            <TableRow sx={{ backgroundColor: "black" }}>
              {[
                "Full Name",
                "Email",
                "Status",
                "Role",
                "",
              ].map((head) => (
                <TableCell
                  key={head}
                  sx={{ color: "white", fontWeight: "bold" }}
                >
                  {head}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>

          <TableBody>
            <TableRow>
              <TableCell></TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </TableContainer>

      {/* Add New User Modal */}
      <NewUser open={open} handleClose={() => setOpen(false)} />
    </Box>
  );
};

export default SettingUsers;
