const { DataTypes } = require("sequelize");
const sequelize = require("../util/database");

const Email = sequelize.define(
  "email",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      allowNull: false,
      autoIncrement: true,
    },
    email: {
      type: DataTypes.STRING,
    },
  },
  { timestamps: false }
);

module.exports = Email;
