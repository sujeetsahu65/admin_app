
module.exports = (superSequelize, DataTypes) =>
{
  const LunchTiming = superSequelize.define('LunchTiming', {
    dayNumber: {
      type: DataTypes.INTEGER,
      field: 'dayname'
    }, // Days 0-6 (Monday to Sunday)
    fromTime: {
      type: DataTypes.TIME,
      field: 'fromtime'
    },
    toTime: {
      type: DataTypes.TIME,
      field: 'totime'
    },
    closeStatus: {
      type: DataTypes.TINYINT(1), defaultValue: 1,
      field: 'close_status'
    }, // 1=Open, 0=Closed
    tableName: {
      type: DataTypes.VIRTUAL,
      get ()
      {
        return 'lunch_timings';  // This value is set manually as it's not in the database
      }
    }
  },

    {
      timestamps: false,
      tableName: "lunch_timings"
    });
  return LunchTiming;
};

// module.exports = Admin;